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

9d2a3a1f2d19f5166c6a94ac32b42538ed0dcdc357c4d1efea948d59e7d7750e  skills/anti-slop/SKILL.md
cef874f8c1143e9933188719ebfdaf05e17b18a48795afa6a920335e4841649e  skills/approval-gate/SKILL.md
33803aea292c2b425b93e01b378e9f548a9dc6a38c8ee28403a0e9ee6d5724b4  skills/architecture-evidence/SKILL.md
b0f82358157d24aaac8209c0136d5fb265ed59b48aac033297cacae7268c85fe  skills/code-api-design/SKILL.md
0bc120b97e33884ed3cabfc3e71210ef9b11bd2ce55c71cd31d523ea2039bc1f  skills/code-code-quality/SKILL.md
9003bf43f32127b392648f6835a74b042a19fa35921584281439a3a81b08aa69  skills/code-design-patterns/SKILL.md
1759edb30dd2c9d0558366abdb1aab6c51b7f5822aa4b37fbcf8a153260a4edc  skills/code-error-handling/SKILL.md
c54a8ea674e5b99229c901ee05c8cd38d9f11e0bdec7b5dd5813b7eabf09ca04  skills/compliance-audit-compliance/SKILL.md
e6edd9ae462ae83bc4145cc16916e7f67873d22f36eb38751faebec31004aa4c  skills/data-data-persistence/SKILL.md
8d5eff380b98563e271803c838cfb62a361088754f578553ae90b983af521939  skills/data-messaging/SKILL.md
72ceb8871e87c670931ad03b0449214dd8749054bce5fd4567b641b79313e3a3  skills/delivery-ci-cd-delivery/SKILL.md
c8ab7dd9b7f530308829e31f47237ddf28e15eb215183a39a81f89f9f7e8e9dd  skills/delivery-infrastructure/SKILL.md
d603b50eaca065604276866aaf97c08b21284b37347ceac91ba738acc98ec119  skills/delivery-release-git/SKILL.md
b5c336fc83f7fb23f73013787042ded3ae89e48a7138fc1257ae6f300e1143c8  skills/design-challenge/SKILL.md
06d4d0ae3f218112dd57d9391cb0db5f8b30f2c119bf3bf7234d86dc1f9d327b  skills/diagram-mermaid/SKILL.md
cfb8b9c567acbc996f2c990818697810ff74c0d9a9cb0d61d36b114dbbf9191a  skills/dry-kiss-yagni/SKILL.md
b158dd88173de601bdf83688707d7ea12606f085af7dbe7521dfdefc96235e44  skills/error-handling/SKILL.md
8991fb07fe1a7339c4346915f48a25b66cfb7e73fe227edab34c4c3474e9801c  skills/future-proof/SKILL.md
da73c48d06985a0f2b0d2988260cab97a125732d448b9e47790ea3e87b52a07d  skills/hard-choice/SKILL.md
d4d040d012c0f568d1adb32a6bc90dc6239d4ecb251dd29dab7ef6ba6eab7ea0  skills/meta-analysis-architecture/SKILL.md
bc56ab622fd1aee7c50527e0f62e9d46066825090e7cb6812fc632af6dd709c4  skills/meta-persuasion-principles/SKILL.md
2cf9c86fdfc58597547746c9868c3247f3fec68bfd914846a2802b8df4989e3b  skills/meta-rearchitect/SKILL.md
ac8abfd92e8973663f33df3845b058b045dc36654e03a75eeb1cdf78846cbc73  skills/naming/SKILL.md
ab2483b513779276777f55a4892501cfcee33d9642f5802ef56b9151def9647e  skills/operations-incident-response/SKILL.md
4c47d4ec873c0e0def5fb5c036ba05dbb63fee2c8b50a52214ed11a8066b88c2  skills/operations-sre-operations/SKILL.md
71ffd7ed2ebdfabce8aa48d0308f91cad73ffc23071b2d26ed48d72b1f2c1692  skills/pareto-focus/SKILL.md
aa3139a31fce444c7065c8d73f04416c687dd2ce2246631d5d35741182312769  skills/quality-debugging-performance/SKILL.md
d6abd6184f63de4d2ca0dee201eaf75f7d999807598a8fc7601795880b63e62f  skills/quality-observability/SKILL.md
dce4af94223ab86a1e8de69d38382fc84600d8744dfe71b31c7e672971968314  skills/quality-testing/SKILL.md
0d84d3626a5d3d4e350a04446d73d11bf0f84998c16a23e217905625dd2cd8f5  skills/review-gate/SKILL.md
dd7d6a9258b8715779f738b69b7ac33ebcfd03447d39a1a54ca81ada577fa82f  skills/root-cause/SKILL.md
9522b83426546c1c157c220de1e36e4dd82c42cc6238d5d271c4d66f3a8646c3  skills/scope-discipline/SKILL.md
3478ab5552e47ea38ced136615f96bddaec6909f18bc265f86016a366451fb06  skills/scout/SKILL.md
b803ebb4653f577f98e2aaa68a92df9909c21010983f5af4d93e6e711c72c91f  skills/security-git/SKILL.md
75309e06a29750b11a2cb3410b73cc485d5651898e7334f0f506a29170ff6587  skills/security-identity-access/SKILL.md
d617431a874823be4bbcf587aa7be91438a0a038ea3c986e8e2b57b6a549b080  skills/security-owasp/SKILL.md
931bfce3212ac4008d4247aa9ce0718c4a7f24f221424043b01022c28a3afc3b  skills/security-secrets-supply-chain/SKILL.md
f6db7bf2e078f03f184c73c6c1c9a3f076a1bf8872a9a35c8ea322f12586918b  skills/solid-gate/SKILL.md
052e3caceb10bbc768c178cd69ee44ee725dd2f7cf9de6a385d4d0f9fb04483c  skills/test-discipline/SKILL.md
b010e7df56a0ec04bf192b0c2a7741159b4b595f979f6fd7ad545337cb5f2639  skills/vcs-conventional-commits/SKILL.md
00150416ae5b63b7ce32255c7c11d926c3988987f10cf17ff6961a00cd66a4bd  skills/vcs-forge-operations/SKILL.md
5870c57027fd09b8774ce1bec52504fda79d88bbcc87fa5c37ec9caa1ca44d62  skills/vcs-git-workflows/SKILL.md
68ff226f33f136f0f20f71d2283feaf5941b8468a9bfb9b59602a6b860dac83f  skills/verification-evidence/SKILL.md
3db95ac2ebb0116c09b7925ef8d4c7d7f040fa2d2294edc7722591a6f85d45b5  skills/x-analyze/SKILL.md
c5834af7ba2a0340c425e68560bc8f410699a04d32a9ffa3fdf5c2bf9c4d2247  skills/x-auto/SKILL.md
464be3f62ddcda2eef348a14fec775801e0bd7d123f66e59aeff4d8ea38ff55d  skills/x-brainstorm/SKILL.md
a71362975e0cafaa1693d3f910a205e5ccf502089c737ed946c29071d55edc26  skills/x-design/SKILL.md
ff6a3a5b0a04901c1239c082d10a84a679b65517423b2ed09e514e76a6cf419c  skills/x-fix/SKILL.md
8248a55ffe359758a839110ce443c861b22aff9ff21f005c5ca9e8c0d7de17fd  skills/x-implement/SKILL.md
90a9369251b4fe82ab9fc2b87606d43645f9ebe148e267deecbd5284eba3e6ab  skills/x-plan/SKILL.md
7289713c8dcad5f8354ea07a136cf34985e15ce91948423fff58d621ad987542  skills/x-research/SKILL.md
6d0ceba1e7a53d18fd5bbd5b3888f721d445b9dbafe5e051fa24a5e314911052  skills/x-review/SKILL.md
f1bb034a4aaa50000d46ceeb409e822111bd5e8e98057ddff142440f21bb730b  skills/x-troubleshoot/SKILL.md
05e5808f95c9446b425cf70839a0fd0456063e37c6f571be9cd1976a4b8de98d  system-prompt.md
