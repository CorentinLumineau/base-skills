# CHECKSUMS
Generated: 2026-06-12
Algorithm: SHA-256

## Verification

```bash
sha256sum --check CHECKSUMS.md  # GNU coreutils (Linux)
shasum -a 256 -c CHECKSUMS.md   # macOS
```

Both commands must exit 0 from the repository root. Any non-zero exit indicates a file
has been modified since this file was generated — investigate before loading skills into
an agent system prompt.

## Regeneration

Run the following from the repository root after any SKILL.md or system-prompt.md change:

```bash
find skills -name 'SKILL.md' | sort | xargs sha256sum
sha256sum system-prompt.md
```

Update the `## Files` section below with the new hashes and update the `Generated:` date
in the header. Keep the two-space separator between hash and path (sha256sum native format)
so that `sha256sum --check` can parse the file without modification.

## Optional CI Enhancement

Add the following step to your CI pipeline to detect checksum drift automatically:

```yaml
- name: Verify skill checksums
  run: sha256sum --check CHECKSUMS.md
```

This gates any PR that modifies a skill file without regenerating CHECKSUMS.md.

## Coverage

This file covers:
- All `skills/*/SKILL.md` files (53 files, all L1/L2/L3 skills)
- `system-prompt.md` (always-on behavioral block)

Not covered (empty files; content pending — see references/resync-process.md for context):
- `references/chain-overview.md` — non-empty as of v0.2.0; included below if non-empty
- `references/workflow-state.md` — non-empty as of v0.2.0; included below if non-empty

Note: `references/chain-overview.md` and `references/workflow-state.md` were verified
non-empty before this file was generated (M5 filled them). They are excluded from
CHECKSUMS.md because they are reference documentation, not agent-loaded skill content.
If you load them as agent context, verify their content independently.

## Files

66ead6cdafc38244e3c6c7852de794792847ee036602f01ec515f6c53b9d4161  skills/anti-slop/SKILL.md
1e0ed98c1e8d6402e0ca1ccb0c3f0506f6ad1e9a74567fb2713885513f65738d  skills/approval-gate/SKILL.md
37057e73d3f0afeae29dec3ecb31f171d3626094741bc1eafeb9072b7910b125  skills/architecture-evidence/SKILL.md
72c243f5c5055e600a6c070f7f42be7227130273e28f55e7ea4e7ada21056c0a  skills/code-api-design/SKILL.md
d087aecfe84c9231208a123d67b5676a5612e4b30aa2b5e0f12eba09fdd20a37  skills/code-code-quality/SKILL.md
64ec04592c025b717d665accb84767eb7741a0f01242f7788aabbe996e46952e  skills/code-design-patterns/SKILL.md
c301e094d63dbc090a69d6a2797b50c9fb987320fb410b02d0e692504d526e76  skills/code-error-handling/SKILL.md
c54a8ea674e5b99229c901ee05c8cd38d9f11e0bdec7b5dd5813b7eabf09ca04  skills/compliance-audit-compliance/SKILL.md
08904be76da42ac0661454a7f6a6c4d515b8a6d3a7ed1d976a62ea235d1c7ed5  skills/data-data-persistence/SKILL.md
929e93e995f29219aa0bf5561513ebb6c4c324b5d56f3f265a36c2287c7bad3e  skills/data-messaging/SKILL.md
72ceb8871e87c670931ad03b0449214dd8749054bce5fd4567b641b79313e3a3  skills/delivery-ci-cd-delivery/SKILL.md
c8ab7dd9b7f530308829e31f47237ddf28e15eb215183a39a81f89f9f7e8e9dd  skills/delivery-infrastructure/SKILL.md
d603b50eaca065604276866aaf97c08b21284b37347ceac91ba738acc98ec119  skills/delivery-release-git/SKILL.md
c483d0cac60fc967a5460a4488f9a83163a0a3338b0beda6b4b9f121ff82a7c3  skills/design-challenge/SKILL.md
06d4d0ae3f218112dd57d9391cb0db5f8b30f2c119bf3bf7234d86dc1f9d327b  skills/diagram-mermaid/SKILL.md
502219741e78bd11ba44c4005a24c3aaf4ba4521c86f302bf76224f31fc8c99b  skills/dry-kiss-yagni/SKILL.md
1da227e283878e0e6fd841178a86483880a95ee845c4b4e8d08b01b556c62073  skills/error-handling/SKILL.md
9ff5dc0d4deafc87d886615962817595ce3bba4d2e2a432bf18064e4576a9fef  skills/future-proof/SKILL.md
54fa54bd1fb351fdc3022c9a4107bfc4ee6cac13ca67cce88c7e2f1562a42ea0  skills/hard-choice/SKILL.md
c52eb8b2a4f0091e788cea7920163850589a5647ac853ea8ce0f879e40a2b2a8  skills/meta-analysis-architecture/SKILL.md
bc56ab622fd1aee7c50527e0f62e9d46066825090e7cb6812fc632af6dd709c4  skills/meta-persuasion-principles/SKILL.md
2cf9c86fdfc58597547746c9868c3247f3fec68bfd914846a2802b8df4989e3b  skills/meta-rearchitect/SKILL.md
492a80d1cd60d36a935e192c8262e7177df0d36d48654db14910e7367aaff260  skills/naming/SKILL.md
ab2483b513779276777f55a4892501cfcee33d9642f5802ef56b9151def9647e  skills/operations-incident-response/SKILL.md
4c47d4ec873c0e0def5fb5c036ba05dbb63fee2c8b50a52214ed11a8066b88c2  skills/operations-sre-operations/SKILL.md
b8541c374da8b9e65bd74442a71f199dce85adaf4704663eb0267038682fd548  skills/pareto-focus/SKILL.md
e15ded339ab5d5c00c3ab6cb1c02bf3ecd2f6ebb603fb4c0f57d4a21f935d444  skills/quality-debugging-performance/SKILL.md
c6f6a7469da6adceffbeabacf885b781b89df2b585e6f7220f046c4a2cfcec93  skills/quality-observability/SKILL.md
49c85f433bde8e8bc433ceeacc4bef49264a8c4eff578e9ab3b9cdffe0b4c7c7  skills/quality-testing/SKILL.md
8d93646319f574177bf3ef713915dbb97b76a9388a4e267422c4a6c3ba75eaba  skills/review-gate/SKILL.md
34dc1310609a7aed9f94d88a8c7589bf06b90d9987d6b1698e93b9c562ec2811  skills/root-cause/SKILL.md
6e9317853b38c4487d67891042c4007ce38578472d90e14fb29da0d58671bc50  skills/scope-discipline/SKILL.md
a367dbbfdd080334fc89058b6188b72e96b3ea5a5f6d78fb77e19b1a0b1b9d89  skills/scout/SKILL.md
59bc33875b194c5839b9262b8765725933ea3c7f79624098b69a8ea8e1af1bb8  skills/security-git/SKILL.md
6c0d4f9f7a2e7a276aa402334757a9cdd0c890ac22b20c7df33690dfdefc1edc  skills/security-identity-access/SKILL.md
2f1348732222a37396f0538a8771bfcf71cb11eccfcd78a9e2e57dbe21338624  skills/security-owasp/SKILL.md
033b7774e483910b659fe10e7080a38f799377af2469fd72f32a80245ca12234  skills/security-secrets-supply-chain/SKILL.md
2f785ed1f7bf85aa5b36b125158535b40d5373ce1b8d573e6da4666ef5bb48c8  skills/solid-gate/SKILL.md
fc234f5c8346b03f13003def52fea1708a4fbc77a525c08fd8f767c719697c48  skills/test-discipline/SKILL.md
bf73fa5739beec482b70cc38da2d8158c5ef44883a60c9c261831658d44489d9  skills/vcs-conventional-commits/SKILL.md
00150416ae5b63b7ce32255c7c11d926c3988987f10cf17ff6961a00cd66a4bd  skills/vcs-forge-operations/SKILL.md
5870c57027fd09b8774ce1bec52504fda79d88bbcc87fa5c37ec9caa1ca44d62  skills/vcs-git-workflows/SKILL.md
bd49eea14186b51caaa043e9b07482a59c66f7bf7e5e7d3fee834f23b8329332  skills/verification-evidence/SKILL.md
523fe7aad45bd11f21a668d921e7662553edcb2429050d3d6fcead8b9637c744  skills/x-analyze/SKILL.md
f223d095d49acf7c2ddba1176807afe730e8821418c4c07fbfdc0bc69381abae  skills/x-auto/SKILL.md
9a1404426c84d7caae8a1e2177f6b3df7871047704ddce16140f4ceb5995b95e  skills/x-brainstorm/SKILL.md
5e4ff00a388e7960928239482cdec70e6ba02db915b7ca58d3f58d07e3d7542f  skills/x-design/SKILL.md
e037cbceb1883451f40e8c0eb6189e4286244bf9ecd5d684725d2e28d237019d  skills/x-fix/SKILL.md
16b9b6d6879389e2def1cb76fbbb75abec09f65b207da96848c1ce6b13c01010  skills/x-implement/SKILL.md
ec42a1821b2ab127c64b216e9599a5e9150b42eab5ac205318a09bfa4effe495  skills/x-plan/SKILL.md
569f892d3a70ec2907d442d8931f310e0b1c619512635212b9cc486d873fb0e7  skills/x-research/SKILL.md
9936f9d8ed914ed36f7a55113aa23b136157de6c724644cd207fc409bb2e634f  skills/x-review/SKILL.md
947c52013567259cca9330b9c936a5fe3c8f2594f9517ad8a685aaa8d59247a4  skills/x-troubleshoot/SKILL.md
05e5808f95c9446b425cf70839a0fd0456063e37c6f571be9cd1976a4b8de98d  system-prompt.md
