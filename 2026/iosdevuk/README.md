# Apps-olutely Secure
## iOSDevUK 2026

I gave a talk about mobile app security on Tue 8<sup>th</sup> September at iOSDevUK in Aberystwyth.

### Overview

The talk covered how to threat model an iOS app: what are we protecting, who's coming for it, how could they get in, and what happens if they win.

Using an example run-tracking app, Swift Pace, I walked through four attacks - a monster-in-the-middle intercepting network traffic, a remote attacker targeting the server, a stolen device, and an insider threat - and the trade-offs (user friction, operational cost, development cost and risk if missed) behind mitigations such as certificate pinning, Certificate Transparency, App Attest, data minimisation, file protection levels, the Keychain and Secure Enclave, and Infrastructure-as-Code. I finished with a look at penetration testing and further reading on mobile security.

### Slides

The slides for this talk can be found [in this repository](Slides.pdf).

The Terraform provider used for the Infrastructure-as-Code example can be found [on GitHub](https://github.com/Oliver-Binns/terraform-provider-appstore).

### Resources

For further information, I'd recommend:

- [Apple Developer - Security Overview](https://developer.apple.com/documentation/security)
- [Mobile Application Security by OWASP](https://owasp.org/www-project-mobile-app-security/)
