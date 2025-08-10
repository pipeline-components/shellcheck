# Pipeline Components: Shellcheck

[![][gitlab-repo-shield]][repository]
![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE)
[![GitLab CI][gitlabci-shield]][gitlabci]

## Docker status

[![Image Size][size-shield]][dockerhub]
[![Docker Pulls][pulls-shield]][dockerhub]

## Usage

The image is for running shellcheck.

## Examples

```yaml
shellcheck:
  stage: linting
  image: registry.gitlab.com/pipeline-components/shellcheck:latest
  script:
    - |
      find . -name .git -type d -prune -o -type f -name \*.sh -print0 |
      xargs -0 -r -n1 shellcheck
```

Or a bit more complex:

```yaml
shellcheck:
  stage: linting
  image: registry.gitlab.com/pipeline-components/shellcheck:latest
  script:
    # anything ending on .sh, should be shell script
    - |
      find . -name .git -type d -prune -o -type f  -name \*.sh -print0 |
      xargs -0 -P $(nproc) -r -n1 shellcheck
    # magic, any file with a valid shebang should be scanned aswell
    - |
      find . -name .git -type d -prune -o -type f  -regex '.*/[^.]*$'   -print0 |
      xargs -0 -P $(nproc) -r -n1 sh -c 'FILE="$0"; if head -n1 "$FILE" |grep -q "^#\\! \?/.\+\(ba|d|k\)\?sh" ; then shellcheck "$FILE" ; else /bin/true ; fi '
```

## Versioning

This project uses [Semantic Versioning][semver] for its version numbering.

## Support

Got questions?

Check the [discord channel][discord]

You could also [open an issue here][issue]

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We've set up a separate document for our [contribution guidelines][contributing-link].

Thank you for being involved! 😍

## Authors & contributors

The original setup of this repository is by [Robbert Müller][mjrider].

The Build pipeline is large based on [Community Hass.io Add-ons
][hassio-addons] by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

This project is licensed under the [MIT License](./LICENSE) by [Robbert Müller][mjrider].

[contributing-link]: https://pipeline-components.dev/contributing/
[contributors]: https://gitlab.com/pipeline-components/shellcheck/-/graphs/main
[discord]: https://discord.gg/vhxWFfP
[dockerhub]: https://hub.docker.com/r/pipelinecomponents/shellcheck
[frenck]: https://github.com/frenck
[gitlab-repo-shield]: https://img.shields.io/badge/Source-Gitlab-orange.svg?logo=gitlab
[gitlabci-shield]: https://img.shields.io/gitlab/pipeline/pipeline-components/shellcheck.svg
[gitlabci]: https://gitlab.com/pipeline-components/shellcheck/-/commits/main
[hassio-addons]: https://github.com/hassio-addons
[issue]: https://gitlab.com/pipeline-components/shellcheck/issues
[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2025.svg
[mjrider]: https://gitlab.com/mjrider
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[pulls-shield]: https://img.shields.io/docker/pulls/pipelinecomponents/shellcheck.svg?logo=docker
[repository]: https://gitlab.com/pipeline-components/shellcheck
[semver]: http://semver.org/spec/v2.0.0.html
[size-shield]: https://img.shields.io/docker/image-size/pipelinecomponents/shellcheck.svg?logo=docker
