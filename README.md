# RestTool

Just a tool written in shell, to make easier both testing and using Restfull API on a console.

The propose here is to create a intuitive way to make Restfull calls, without repeating the same parameters several times.

For example:

```
$ rest -h https://api.github.com -u whatever:pwd
$ rest GET /repos/octokit/octokit.rb
...
$ rest GET /orgs/octokit/repos
...
$ rest GET /user/repos page=2 per_page=5
```

POST example:

```shell
$ rest POST /authorizations '{"scopes":["public_repo"]}'
```

Extra Header example

```shell
$ rest GET /user/repos 'TimeZone:America/Sao_Paulo'

```

## Usage

```text
Usage: rest [options...] [verb] [resource] [ [data...] | [header...] ]
```

**Options:**
- -h ENDPOINT    Default Endpoint to work with. The host for API requests.
- -u USER[:PWD]  Default server user.
- [curl ops]     Any other CURL option, except -h and -u

**Resouce:** Path to the Rest API resource.

**Verb:** Any HTTP Verb (GET, POST, HEADER, PUT, DELETE, etc...)

**Data:** Data do send. If used with GET, data will put on the final URL. Other verbs, resttool will will pass the data to the server using the content-type application/x-www-form-urlencoded.
- _key=value_      Use a pair key-value to pass data to server

**Header:** You can pass extra header to include in the request. You may specify any number of extra headers.
- _header:value_   Use this form to send extra headers. 

## TODO

- [ ] Save default Header data
- [ ] Support other curl parameters
- [ ] Support Long options
- [ ] Custom config files (maybe based on current dir)