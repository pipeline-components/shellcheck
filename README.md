# Pipeline Components: Shellcheck

![Project Stage][project-stage-shield]
![Project Maintenance][maintenance-shield]
[![License][license-shield]](LICENSE)

[![GitLab CI][gitlabci-shield]][gitlabci]

## Docker status

[![Docker Version][version-shield]][microbadger]
[![Docker Layers][layers-shield]][microbadger]
[![Docker Pulls][pulls-shield]][dockerhub]

## Usage

The image is for running shellcheck. The image is based on alpine:3.8

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

We've set up a separate document for our [contribution guidelines](CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Authors & contributors

The original setup of this repository is by [Robbert Müller][mjrider].

The Build pipeline is large based on [Community Hass.io Add-ons
][hassio-addons] by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2018 Robbert Müller

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[commits]: https://gitlab.com/pipeline-components/shellcheck/commits/master
[contributors]: https://gitlab.com/pipeline-components/shellcheck/graphs/master
[dockerhub]: https://hub.docker.com/r/pipelinecomponents/shellcheck
[license-shield]: https://img.shields.io/badge/License-MIT-green.svg
[mjrider]: https://gitlab.com/mjrider
[discord]: https://discord.gg/vhxWFfP
[gitlabci-shield]: https://img.shields.io/gitlab/pipeline/pipeline-components/shellcheck.svg
[gitlabci]: https://gitlab.com/pipeline-components/shellcheck/commits/master
[issue]: https://gitlab.com/pipeline-components/shellcheck/issues
[keepchangelog]: http://keepachangelog.com/en/1.0.0/
[layers-shield]: https://images.microbadger.com/badges/image/pipelinecomponents/shellcheck.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2020.svg
[microbadger]: https://microbadger.com/images/pipelinecomponents/shellcheck
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[pulls-shield]: https://img.shields.io/docker/pulls/pipelinecomponents/shellcheck.svg
[releases]: https://gitlab.com/pipeline-components/shellcheck/tags
[repository]: https://gitlab.com/pipeline-components/shellcheck
[semver]: http://semver.org/spec/v2.0.0.html
[version-shield]: https://images.microbadger.com/badges/version/pipelinecomponents/shellcheck.svg

[frenck]: https://github.com/frenck
[hassio-addons]: https://github.com/hassio-addons
