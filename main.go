package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/google/go-github/v31/github"
	"github.com/hashicorp/go-version"
	"golang.org/x/oauth2"
	"gopkg.in/yaml.v2"
)

type config struct {
	BaseDir     string `yaml:"baseDir"`
	BaseVersion string `yaml:"baseVersion"`
	Maintainer  string `yaml:"maintainer"`
	Plugins     []struct {
		ID              string `yaml:"id"`
		StripComponents int    `yaml:"stripComponents"`
		Dir             string `yaml:"dir"`
		Github          string `yaml:"github"`
	}
}

func main() {
	var httpClient *http.Client
	if os.Getenv("GITHUB_TOKEN") != "" {
		ctx := context.Background()
		ts := oauth2.StaticTokenSource(
			&oauth2.Token{AccessToken: os.Getenv("GITHUB_TOKEN")},
		)
		httpClient = oauth2.NewClient(ctx, ts)
	}

	client := github.NewClient(httpClient)
	yamlFile, err := ioutil.ReadFile("conf.yaml")
	if err != nil {
		panic(fmt.Errorf("yamlFile.Get err   #%v ", err))
	}

	c := &config{}

	err = yaml.Unmarshal([]byte(yamlFile), &c)
	if err != nil {
		log.Fatalf("error: %v", err)
	}
	fmt.Printf("FROM %s\n", c.BaseVersion)
	fmt.Printf("MAINTAINER %s\n", c.Maintainer)
	fmt.Println("")
	fmt.Println("# Install all the plugins")
	// loop through plugins
	for idx := range c.Plugins {
		plugin := c.Plugins[idx]
		org := strings.Split(plugin.Github, "/")[0]
		repo := strings.Split(plugin.Github, "/")[1]

		var newestRelease *github.RepositoryRelease
		releases, _, err := client.Repositories.ListReleases(context.Background(), org, repo, nil)
		if err != nil {
			panic(fmt.Errorf("Error getting releases for plugin %s - #%v ", plugin.Github, err))
		}
		for idx := range releases {
			if *releases[idx].Prerelease {
				continue
			}
			releaseVersion, err := version.NewVersion(*releases[idx].TagName)

			if err != nil {
				continue
			}

			if newestRelease == nil {
				newestRelease = releases[idx]
			}
			newestReleaseVersion, err := version.NewVersion(*newestRelease.TagName)
			if err != nil {
				continue
			}
			if newestReleaseVersion.LessThan(releaseVersion) {
				newestRelease = releases[idx]
			}
		}
		if len(newestRelease.Assets) != 1 {
			log.Fatalf("Too many assets for release %d for %s", newestRelease.ID, plugin.Github)
		}
		fmt.Printf(
			"RUN mkdir -p %s/apps/%s \\\n && curl -sL %s | tar xz --strip-components=%d -C %s/apps/%s\n",
			c.BaseDir,
			plugin.ID,
			*newestRelease.Assets[0].BrowserDownloadURL,
			plugin.StripComponents,
			c.BaseDir,
			plugin.ID,
		)
	}
	fmt.Println("")
	fmt.Println("# once installed, apps dir should not be writable")
	fmt.Printf("RUN chown nobody: -R %s/apps\n", c.BaseDir)
	fmt.Printf("VOLUME [\"%s/data\", \"%s/config\"]\n", c.BaseDir, c.BaseDir)
	fmt.Println("EXPOSE 80")
}
