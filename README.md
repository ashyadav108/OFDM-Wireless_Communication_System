# OFDM Wireless Communication System

## Overview

This project implements and simulates an **OFDM-based wireless communication system using MATLAB**.

The system uses **16-QAM modulation, IFFT/FFT processing, cyclic prefix, and an AWGN channel** to transmit and recover digital data. System performance is evaluated by calculating the **Bit Error Rate (BER)** under different Signal-to-Noise Ratio (SNR) conditions.

The simulation evaluates the system from **0 dB to 20 dB SNR** and demonstrates improved communication reliability as the SNR increases.

---

## Objectives

- Design an OFDM-based wireless communication system.
- Implement 16-QAM modulation and demodulation.
- Implement OFDM using IFFT and FFT.
- Add and remove a cyclic prefix.
- Model an AWGN wireless channel.
- Simulate different SNR conditions.
- Calculate BER at each SNR.
- Analyze system performance using a BER vs. SNR curve.

---

## System Configuration

| Parameter | Value |
|---|---:|
| Modulation | 16-QAM |
| Bits per Symbol | 4 |
| FFT/IFFT Size | 64 |
| Cyclic Prefix | 16 samples |
| OFDM Symbols | 100 |
| SNR Range | 0–20 dB |
| SNR Step | 5 dB |
| Channel Model | AWGN |
| Performance Metric | BER |

---

## System Architecture

```text
                 TRANSMITTER
                     
Random Bits
     │
     ▼
16-QAM Modulation
     │
     ▼
OFDM Symbol Mapping
     │
     ▼
64-Point IFFT
     │
     ▼
Cyclic Prefix Addition
     │
     ▼
     ├───────────────► AWGN Channel
     │                       │
     │                       ▼
     │               Received Signal
     │
     ▼
                 RECEIVER

Remove Cyclic Prefix
     │
     ▼
64-Point FFT
     │
     ▼
16-QAM Demodulation
     │
     ▼
Recovered Bits
     │
     ▼
BER Calculation
```

---

## 1. 16-QAM Modulation

The transmitter generates random binary data and groups the bits into sets of four.

Since:

```text
log2(16) = 4 bits per symbol
```

each group of four bits is mapped to a 16-QAM symbol.

MATLAB's normalized QAM modulation is used:

```matlab
qammod(..., 'UnitAveragePower', true)
```

This produces complex-valued modulation symbols suitable for OFDM transmission.

---

## 2. OFDM Transmitter

The modulated QAM symbols are arranged into OFDM symbols containing **64 subcarriers**.

A 64-point IFFT converts the frequency-domain symbols into time-domain samples:

```matlab
ofdmTime = ifft(ofdmGrid, Nfft, 1);
```

A cyclic prefix of **16 samples** is then added to each OFDM symbol.

Therefore, each transmitted OFDM symbol contains:

```text
64 + 16 = 80 samples
```

The cyclic prefix helps preserve the OFDM symbol structure during transmission and provides protection against inter-symbol interference.

---

## 3. AWGN Channel

The transmitted OFDM signal is passed through an **Additive White Gaussian Noise (AWGN)** channel.

The noise power is calculated according to the selected SNR:

```text
SNR = Signal Power / Noise Power
```

The simulation evaluates:

```text
0 dB
5 dB
10 dB
15 dB
20 dB
```

At lower SNR, the received signal contains more noise relative to the transmitted signal.

At higher SNR, the received signal is less affected by noise.

---

## 4. OFDM Receiver

The received signal is first divided into individual OFDM symbols.

### Cyclic Prefix Removal

The 16-sample cyclic prefix is removed:

```matlab
rxWithoutCP = ...
    rxOFDM(cpLength+1:end, :);
```

### FFT

The remaining time-domain samples are converted back into the frequency domain using a 64-point FFT:

```matlab
rxQAMGrid = ...
    fft(rxWithoutCP, Nfft, 1);
```

The resulting QAM symbols are then passed to the demodulator.

---

## 5. 16-QAM Demodulation

The received QAM symbols are converted back into symbol indices using:

```matlab
qamdemod(...)
```

The symbol indices are then converted back into binary data.

The recovered bits are compared with the original transmitted bits to determine the number of bit errors.

---

## 6. BER Calculation

The Bit Error Rate is calculated as:

```text
BER = Number of Bit Errors / Total Number of Transmitted Bits
```

For each SNR value, the simulation transmits:

```text
25,600 bits
```

and calculates the resulting BER.

---

# Results

The completed simulation produced the following results:

| SNR (dB) | Bit Errors | BER |
|---:|---:|---:|
| 0 | 7373 | 2.880078e-01 |
| 5 | 4198 | 1.639844e-01 |
| 10 | 1489 | 5.816406e-02 |
| 15 | 124 | 4.843750e-03 |
| 20 | 0 | 0.000000e+00 |

---

## Performance Analysis

The simulation demonstrates a clear relationship between SNR and BER.

At **0 dB**, the system experiences a relatively high BER of:

```text
2.880078e-01
```

As the SNR increases, the noise contribution decreases and the receiver is able to recover the transmitted data more reliably.

At **15 dB**:

```text
BER = 4.843750e-03
```

At **20 dB**, no bit errors were observed in the 25,600 simulated bits:

```text
BER = 0
```

Thus, the simulation demonstrates that **higher SNR results in improved communication reliability and lower BER**.

> Note: A BER of zero at 20 dB means that no errors occurred within the finite set of bits simulated. It does not imply that the theoretical BER is exactly zero.

---

## BER Performance

The simulation generates a BER versus SNR plot using MATLAB's `semilogy` function.

The expected behavior is:

```text
BER
│\
│ \
│  \
│   \
│    \
│     \________
│
└────────────────── SNR
  0   5   10  15  20 dB
```

The downward trend indicates improved system performance with increasing SNR.

---

## Project Structure

```text
OFDM_Wireless_Communication_System/
│
├── README.md
│
├── matlab/
│   │
│   ├── modulation/
│   │   └── qam_modulation.m
│   │
│   ├── ofdm/
│   │   ├── ofdm_transmitter.m
│   │   └── ofdm_receiver.m
│   │
│   ├── channel/
│   │   └── awgn_channel.m
│   │
│   ├── simulation/
│   │   └── ofdm_simulation.m
│   │
│   └── analysis/
│       └── plot_results.m
│
└── results/
    └── ofdm_results.mat
```

---

## MATLAB Files

### `qam_modulation.m`

Implements and verifies 16-QAM modulation.

Functions include:

- Random bit generation
- Bit grouping
- Symbol mapping
- 16-QAM modulation
- Constellation visualization

---

### `ofdm_transmitter.m`

Implements the OFDM transmitter.

Main operations:

- Generate random bits
- Perform 16-QAM modulation
- Arrange QAM symbols into OFDM symbols
- Perform 64-point IFFT
- Add 16-sample cyclic prefix
- Generate serial OFDM transmission signal

---

### `ofdm_receiver.m`

Implements and verifies the OFDM receiver without noise.

Main operations:

- Reshape received OFDM signal
- Remove cyclic prefix
- Perform 64-point FFT
- Perform 16-QAM demodulation
- Recover transmitted bits
- Calculate BER

The ideal transmission chain was successfully verified with:

```text
Bit errors = 0
BER = 0
```

---

### `awgn_channel.m`

Implements the AWGN channel.

The script:

- Calculates transmitted signal power
- Calculates noise power from SNR
- Generates complex Gaussian noise
- Adds noise to the transmitted OFDM signal

---

### `ofdm_simulation.m`

This is the **main simulation script**.

It integrates the complete OFDM transmitter, AWGN channel, and receiver.

The simulation evaluates:

```text
SNR = 0, 5, 10, 15, 20 dB
```

and calculates BER for every SNR condition.

The results are saved as:

```text
results/ofdm_results.mat
```

---

### `plot_results.m`

Loads the saved simulation results and performs the final performance analysis.

It:

- Loads `ofdm_results.mat`
- Displays BER values
- Generates the BER vs. SNR plot
- Prints key performance observations

---

## How to Run

### Step 1 — Open MATLAB

Open the project folder:

```text
OFDM_Wireless_Communication_System
```

---

### Step 2 — Run the OFDM transmitter

Navigate to:

```text
matlab/ofdm/
```

Run:

```matlab
ofdm_transmitter
```

---

### Step 3 — Verify the OFDM receiver

Run:

```matlab
ofdm_receiver
```

The ideal transmission path should produce:

```text
Bit errors : 0
BER        : 0.000000
```

---

### Step 4 — Test the AWGN channel

Navigate to:

```text
matlab/channel/
```

Run:

```matlab
awgn_channel
```

---

### Step 5 — Run the complete BER simulation

Navigate to:

```text
matlab/simulation/
```

Run:

```matlab
ofdm_simulation
```

This generates:

```text
results/ofdm_results.mat
```

---

### Step 6 — Analyze the results

Navigate to:

```text
matlab/analysis/
```

Run:

```matlab
plot_results
```

This generates the final BER vs. SNR performance plot.

---

## Tools and Technologies

- MATLAB
- Digital Communication
- 16-QAM
- OFDM
- IFFT / FFT
- Cyclic Prefix
- AWGN Channel
- BER Analysis
- SNR Performance Analysis

---

## Key Concepts Demonstrated

This project demonstrates practical understanding of:

- Digital modulation and demodulation
- 16-QAM
- Orthogonal Frequency Division Multiplexing
- Frequency-domain and time-domain signal processing
- IFFT/FFT-based OFDM implementation
- Cyclic prefix
- AWGN channel modeling
- Signal-to-noise ratio
- Bit Error Rate
- Wireless communication performance analysis

---

## Resume Description

**OFDM Wireless Communication System — MATLAB**

> Designed and simulated an OFDM-based wireless communication system in MATLAB using 16-QAM modulation, FFT/IFFT, cyclic prefix, and AWGN channel modeling. Analyzed communication performance by evaluating BER under different SNR conditions.