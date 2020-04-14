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
	"golang.org/x/oauth2"
	"gopkg.in/yaml.v2"
)

type Config struct {
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

	c := &Config{}

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

		release, _, err := client.Repositories.GetLatestRelease(context.Background(), org, repo)
		if err != nil {
			fmt.Println(err)
			return
		}
		if len(release.Assets) != 1 {
			log.Fatalf("Too many releases for %s", plugin.Github)
		}
		fmt.Printf(
			"RUN mkdir -p %s/apps/%s \\\n && curl -sL %s | tar xz --strip-components=%d -C %s/apps/%s\n",
			c.BaseDir,
			plugin.ID,
			*release.Assets[0].BrowserDownloadURL,
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
