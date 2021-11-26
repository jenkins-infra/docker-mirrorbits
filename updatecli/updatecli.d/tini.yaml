source:
  name: Get Latest helm release version
  kind: githubRelease
  spec:
    owner: "krallin"
    repository: "tini"
    token: {{ requiredEnv .github.token }}
    username: {{ .github.username }}
    version: latest
targets:
  updateARGTINIVERSIONSet:
    name: Update ARG TINI_VERSION
    kind: dockerfile
    prefix: "tini_version="
    spec:
      file: Dockerfile
      Instruction: ARG[1][0]
    scm:
      github:
        user: {{ .github.user }}
        email: {{ .github.email }}
        owner: {{ .github.owner }}
        repository: {{ .github.repository }}
        token: {{ requiredEnv .github.token }}
        username: {{ .github.username }}
        branch: {{ .github.branch }}
