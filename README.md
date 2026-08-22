# PrintShield

> **Private Documents. Your Control.**

PrintShield is a privacy-focused printing system designed to give users temporary, controlled access to sensitive documents when printing at third-party print shops.

Instead of permanently sending a document to a print shop through WhatsApp, email, or another file-sharing service, PrintShield is designed around **temporary print authorization**.

The user chooses a document, reviews sensitive information, defines how many copies may be printed, sets an expiry time, and generates a temporary QR code that can be used to pair with a print shop.

The long-term goal is simple:

> **Your document should leave your phone only on your terms.**

---

## 🚨 The Problem

Printing sensitive documents at a third-party shop creates a privacy problem.

A typical workflow looks like:


Personal Document
       ↓
WhatsApp / Email
       ↓
Print Shop Computer
       ↓
     Print


Once the document has been sent, the user has very little control over what happens to it.

For example:

* The file may remain on the shop's computer.
* The document may be copied or forwarded.
* Sensitive information may be exposed through screenshots.
* The user cannot easily verify whether the file was deleted.
* There is no built-in mechanism for temporary access or revocation.

This is particularly concerning for documents containing information such as Aadhaar numbers, PAN details, passports, financial information, or other personally identifiable information.

---

## 💡 The Solution

PrintShield changes the concept from:

> **Send the document to the print shop.**

to:

> **Authorize the print shop to perform a specific print job for a limited amount of time.**

The user controls:

* Which document is being printed
* Which sensitive information is shown
* How many copies can be printed
* How long the print authorization remains valid
* Which print shop/device is paired with the job

The current MVP demonstrates this workflow through a Flutter Android application.

---

# 🔄 Product Flow

Select Doc -> Review Sensitive Info -> Set Copy Limit (1/2/3) -> Set Expiry Time (5/15/30 mins) -> Generate QR -> Pair With Shop -> Verify Settings -> Print/Expire

# 📱 Current MVP

The current MVP is a Flutter Android application demonstrating the privacy-first printing experience.

### Implemented

* Animated PrintShield splash screen
* Black-and-purple UI
* Home dashboard
* Document selection interface
* Sensitive-data review interface
* Copy-limit selection
* Expiry selection
* Real QR code generation using `qr_flutter`
* Live QR expiry countdown
* Simulated print-shop pairing
* Adaptive privacy score
* Local privacy/settings verification
* Debug APK build
* Flutter analyzer and tests

The MVP is primarily focused on demonstrating the **UX and temporary QR authorization concept** rather than claiming production-grade document security.

---

# 🔐 Temporary QR Authorization

The QR code is intentionally designed to contain **authorization metadata rather than the document itself**.

Conceptually:

QR CODE
   │
   ├── Job Reference ID
   ├── Expiry Timestamp
   └── Timestamp


It does **not** contain:

`
❌ Document content
❌ Aadhaar number
❌ PAN number
❌ Passport information


The document remains on the user's device until the print authorization process is completed.

Once the expiry period is reached, the authorization becomes invalid.

---

# 📊 Privacy Score

PrintShield includes an adaptive privacy score designed to help users understand the trade-off between convenience and control.

For example:

1 copy + 5 minutes
        ↓
   Higher score

3 copies + 30 minutes
        ↓
   Lower score


The score is intentionally a **UX heuristic**, not a cryptographic security measurement.

It communicates:

> Fewer copies + shorter authorization lifetime = greater user control.

It should **not** be interpreted as a guarantee of security.

---

# 🏗️ Architecture

### Current MVP
 
Flutter App-------|------->Document Selection
                  |------->QR Generator
                  |-------> Privacy UX


### Planned Architecture


User-------> Flutter Client-----> Encrypted Request------> PrintShield Backend ---> Print Shop Client ----> Printer




# 🛡️ Security Roadmap

The MVP does not currently implement the complete security architecture.

The planned Phase 2 security layer includes:

### 1. Encrypted document transport

Use established encryption such as:

* AES-GCM
* ChaCha20-Poly1305

Documents should never be transmitted as plaintext.

### 2. Authenticated shop pairing

Print shops should have cryptographically verifiable identities.

A shop should be able to prove:

> "I am the authorized print destination."

### 3. One-time nonces

One-time values can help prevent replaying an old print authorization.

### 4. Temporary authorization tokens

Access should be:

```text
Valid
  ↓
Until expiry
  ↓
Automatically invalid
```

### 5. Secure deletion

After the job expires or completes, temporary document data should be securely removed.

### 6. Sensitive-data redaction

Users should eventually be able to mask sensitive fields before transmission.

Example:

```text
Aadhaar:

XXXX XXXX 1234
```

instead of exposing the complete number.

### Important

PrintShield will use established cryptographic libraries rather than attempting to implement custom cryptography.

---

# ⛓️ Ethereum Integration

Ethereum is **not intended to store documents**.

Putting sensitive documents directly on-chain would defeat the purpose of a privacy-focused printing system.

Instead, a future implementation can create a cryptographic commitment to the print-job metadata.

Conceptually:

```text
Print Job
    │
    ├── Job ID
    ├── Timestamp
    ├── Copy Limit
    └── Expiry
         │
         ▼
       HASH
         │
         ▼
      Ethereum
```

Only the cryptographic hash/commitment is stored on-chain.

This can provide:

* Tamper-evident job history
* Verifiable timestamps
* Transparent auditability
* Third-party verification

while keeping the actual document off-chain.

Ethereum is therefore an **optional accountability layer**, not the storage layer.

---

# 🤖 Future AI Integration

A future version can add AI-assisted privacy protection.

Potential capabilities include:

### Sensitive Information Detection

Automatically detect information such as:

* Aadhaar numbers
* PAN numbers
* Passport numbers
* Phone numbers
* Addresses
* Other personally identifiable information

The system could then warn:

```text
⚠️ Sensitive information detected

Aadhaar number found
Passport number found

[Review Before Printing]
```

### Intelligent Redaction

AI could suggest fields that should be hidden before printing.

The user always remains in control of the final decision.

---

# ⚠️ Current Limitations

This repository represents an MVP/prototype.

The following features are **not yet implemented**:

* Real document picker/upload
* End-to-end encrypted document transport
* Real print-shop client
* Real printer integration
* Backend infrastructure
* Production shop authentication
* OCR-based sensitive-field detection
* Persistent job storage
* Real revocation
* Production secure deletion
* Ethereum integration

The current print-shop interaction is simulated.

The privacy score is also a UX heuristic rather than a security guarantee.

---

# 🛠️ Tech Stack

### Frontend

* Flutter
* Dart

### QR

* `qr_flutter`

### Planned Backend

* Secure API
* Authenticated print-shop client
* Temporary job authorization

### Planned Security

* AES-GCM / ChaCha20-Poly1305
* Digital signatures
* One-time nonces
* Temporary authorization tokens

### Planned Web3

* Ethereum
* Cryptographic job commitments

### Planned AI

* OCR / sensitive-information detection
* Privacy-aware redaction assistance

---

# 🚀 Getting Started

Make sure Flutter is installed and configured.

Clone the repository and install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

Build an Android debug APK:

```bash
flutter build apk --debug
```

The generated APK can be found at:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

---

# 🗺️ Roadmap

## Phase 1 — MVP

* [x] Flutter Android application
* [x] PrintShield UI
* [x] Document-selection flow
* [x] Copy limits
* [x] Expiry limits
* [x] QR generation
* [x] QR countdown
* [x] Simulated shop pairing
* [x] Privacy score

## Phase 2 — Secure Printing

* [ ] Real document picker
* [ ] Backend API
* [ ] Print-shop client
* [ ] Encrypted document transport
* [ ] Authenticated pairing
* [ ] Temporary authorization
* [ ] Secure deletion
* [ ] Real printer integration

## Phase 3 — Intelligent Privacy

* [ ] OCR
* [ ] Sensitive-field detection
* [ ] Automatic redaction suggestions
* [ ] Privacy recommendations

## Phase 4 — Ethereum

* [ ] Job manifest hashing
* [ ] Ethereum commitment
* [ ] Verifiable audit history
* [ ] Public verification interface

---

# 🎯 Vision

PrintShield is built around a simple idea:

> **Sending a document to a print shop shouldn't mean giving up control over it.**

The goal is to make printing sensitive documents feel more like granting a temporary permission than permanently sharing a file.

```text
Traditional Printing

SEND ───────────────► SHOP
                       │
                       └── Control lost


PrintShield

AUTHORIZE ──────────► SHOP
     │                 │
     │                 ▼
     │              PRINT
     │                 │
     └──── EXPIRES ◄───┘
```

**Private Documents. Your Control.**
