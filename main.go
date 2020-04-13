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
	Maintainer  string
	Plugins     []struct {
		ID              string
		StripComponents int
		Dir             string
		Github          string
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
			"RUN mkdir -p %s/%s \\\n && curl -sL %s | tar xz --strip-components=%d -C %s/%s\n",
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
	fmt.Printf("RUN chown nobody: -R %s /usr/src/nextcloud/custom_apps\n", c.BaseDir)
	fmt.Println("VOLUME [\"/usr/src/nextcloud/data\", \"/usr/src/nextcloud/config\"]")
	fmt.Println("EXPOSE 80")
}
