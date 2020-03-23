# docker-plantuml

:robot: Packages in Dockerfile are automatically updated though GitHub Actions :robot:

[![Actions Status](https://github.com/go-zen-chu/docker-plantuml/workflows/push-image/badge.svg)](https://github.com/go-zen-chu/docker-plantuml/actions)
[![Actions Status](https://github.com/go-zen-chu/docker-plantuml/workflows/update-image/badge.svg)](https://github.com/go-zen-chu/docker-plantuml/actions)

[dockerhub: amasuda/plantuml-cli](https://hub.docker.com/repository/docker/amasuda/plantuml-cli)

plantuml-cli image for CI (e.g. generating plantuml image when merged to master)

## usage

You can easily use plantuml command like below.

```bash
docker pull amasuda/plantuml-cli:latest
docker run --rm -v <your plantuml file path>:/tmp amasuda/plantuml-cli:latest plantuml /tmp/<your plantuml file name>
# example
# docker run --rm -v ${PWD}/test.puml:/tmp amasuda/plantuml-cli:latest plantuml /tmp/test.puml
# this will generate test.png on ${PWD}
```

Running plantuml command on CI, you can generate image and upload (or commit) it.

## development

Image tag corresponds to git commit hash (if not skipped).

You can try updating Dockerfile through `make update`. Should work on Linux, MacOS
