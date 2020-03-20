# docker-plantuml

[![Actions Status](https://github.com/go-zen-chu/docker-plantuml/workflows/push-image/badge.svg)](https://github.com/go-zen-chu/docker-plantuml/actions)

[dockerhub: amasuda/plantuml-cli](https://hub.docker.com/repository/docker/amasuda/plantuml-cli)

plantuml-cli image for CI (e.g. generating plantuml image when merged to master)

This image tries to automate required packages on GitHub Actions.

## usage

```bash
$ docker pull amasuda/plantuml-cli:latest
```

Image tag corresponds to git commit hash (if not skipped).