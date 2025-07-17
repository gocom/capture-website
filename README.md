Capture website
=====

Image: `ghcr.io/gocom/capture-website` | [Container Registry](https://github.com/gocom/capture-website/pkgs/container/capture-website)

Docker image for capturing screenshots of websites. The image wraps around
[capture-website](https://github.com/sindresorhus/capture-website) and
[capture-website-cli](https://github.com/sindresorhus/capture-website-cli), which
internally in uses [Puppeteer](https://github.com/puppeteer/puppeteer) and headless Chrome for taking screenshots
of websites.

⚡ Usage
-----

The **capture-website** CLI utility, that is wrapped within the container, can be accessed as so:

```shell
$ docker run --cap-add=SYS_ADMIN --rm --volume ./screenshots:/app/screenshots ghcr.io/gocom/capture-website:0.1.0 --help
```

The above would print capture-website's CLI help document. Substitute the `0.1.0` with the version tag you want to use.
It is recommended that you reference specific version or hash. The image follows
[Semantic Versioning](https://semver.org/).

If the command passed to the container is not an existing executable, starts with `--` or `capture-website`,
the given command is passed down through the entrypoint to `capture-website`, where the process is run as `app:app`
user. If the container is started as a root, the `app` user is automatically mapped to the user defined with `HOST_UID`
environment variable.

❕Note that the image requires `SYS_ADMIN` capability since the container runs a sandboxed browser process inside of
it. The image may work without it on some host systems, but will fail on others.

📝 Example usage
-----

### Basic Docker CLI usage

The following would take screenshot of the given URL and save results to the screenshots directory:

```shell
$ docker run --rm --volume ./screenshots:/app/screenshots ghcr.io/gocom/capture-website:0.1.0 https://example.com/ --output=/screenshots/sreenshot.png
```

In the above, substitute the version number tag with the version you want.

### With Docker Compose

Docker Compose is a common way to orchestrate containers in local development environments. When using Docker Compose,
the **capture-website** service can use and access Docker networks and hostname mappings. For example:

```yml
services:
  nginx:
    image: nginx:mainline
    networks:
      - proxy

  capture-website:
    image: ghcr.io/gocom/capture-website:0.1.0
    volumes:
      - ./screenshots:/screenshots
    networks:
      - proxy
    cap_add:
      - SYS_ADMIN

networks:
  proxy:
```

The `capture-website` can now access the `nginx` hostname to take screenshots of it:

```shell
$ docker compose run --rm capture-website http://nginx/ --output=/screenshots/sreenshot.png
```

🫧 Configuration
-----

The container and its tooling can be configured with environment variables and with CLI options when running commands.

### Environment variables

The following environment variables can be used to customize the generated certificates.

| Variable   | Default Value | Description                                                                                                                                                |
|------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `HOST_UID` | `1000`        | If the container is started as root, maps the default start up command's user to the specified UID. Generated files will be owned by the specified user.   |
| `HOST_GID` | `1000`        | If the container is started as root, maps the default start up command's group as the specified GID. Generated files will be owned by the specified group. |

### Puppeteer

The Puppeteer running inside the container can be configured with environment variables. See available options in
[Puppeteer's configuration docs](https://pptr.dev/api/puppeteer.configuration).

### capture-website

The capture-website CLI inside the container can be configured with command line flags and options. The options are
then passed down to the [capture-website](https://github.com/sindresorhus/capture-website) library. For available
options see the capture-website CLI's [README.md](https://github.com/sindresorhus/capture-website-cli) or the CLI's
`--help` flag.

🛠️ Development
-----

See [CONTRIBUTING.md](https://raw.github.com/gocom/capture-website/master/CONTRIBUTING.md).
