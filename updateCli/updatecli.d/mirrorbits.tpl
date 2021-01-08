source:
  name: Get Latest mirrorbits release version
  kind: githubRelease
  spec:
    owner: "etix"
    repository: "mirrorbits"
    token: {{ requiredEnv .github.token }}
    username: {{ .github.username }}
    version: latest
targets:
  updateMIRRORBITSARGVERSION1:
    name: Update builder image ARG mirrorbits_version
    kind: dockerfile
    prefix: "mirrorbits_version="
    spec:
      file: Dockerfile
      Instruction: ARG[0][0]
    scm:
      github:
        user: {{ .github.user }}
        email: {{ .github.email }}
        owner: {{ .github.owner }}
        repository: {{ .github.repository }}
        token: {{ requiredEnv .github.token }}
        username: {{ .github.username }}
        branch: {{ .github.branch }}
  updateMIRRORBITSARGVERSION2:
    name: Update final ARG mirrorbits_version
    kind: dockerfile
    prefix: "mirrorbits_version="
    spec:
      file: Dockerfile
      Instruction: ARG[2][0]
    scm:
      github:
        user: {{ .github.user }}
        email: {{ .github.email }}
        owner: {{ .github.owner }}
        repository: {{ .github.repository }}
        token: {{ requiredEnv .github.token }}
        username: {{ .github.username }}
        branch: {{ .github.branch }}
