# ☕ FPGA Controlled Automated Coffee Maker using Verilog

## 📌 Project Overview

This project presents an **automated coffee vending machine** that is controlled using an FPGA board and written entirely in **Verilog HDL**. The coffee machine takes user input such as **flavour**, **sugar level**, and **cup detection** to dispense a perfect coffee. The machine simulates different coffee options like **Espresso**, **Cappuccino**, **Latte**, and **Mocha**, offering both digital logic design skills and practical automation experience.

---

## 🧠 Features

- Cup detection using IR Sensor
- Temperature control and monitoring
- Sugar and flavor selection
- LED indicators for selections and progress
- Automated dispensing of milk, water, coffee powder, and syrup
- Completion alert using a buzzer

---

## 📸 Poster and Design

### Cover Page

![Poster Cover](./f55f72a4-a42d-4f5c-a72c-785ca77fc0ac.jpg)

---

### Block Diagram and Flowchart

![Block Diagram and Flowchart](./26dc4b90-3d81-49f5-8804-b66a2fac4bbf.jpg)

---

### Timing Diagram (Simulation Output)

![Simulation Output](./b62344c5-91ca-4b1d-bdd7-fc183f697f07.jpg)

---

## ⚙️ Hardware Requirements

- FPGA development board (e.g., Xilinx Spartan or equivalent)
- IR sensor
- LED indicators
- Buzzer
- Temperature sensor
- Actuators for dispensers (simulated)

---

## 🧾 File Structure

| File Name         | Description                              |
|------------------|------------------------------------------|
| `coffee.v`        | Main Verilog code for the coffee maker FSM |
| `coffee_tb.v`     | Testbench for simulating the coffee maker  |
| `README.md`       | Project documentation (this file)         |

---

## 🧩 Functional Flow

1. **Idle State** – Wait for IR sensor to detect a cup.
2. **Flavour Select** – User selects coffee flavour.
3. **Sugar Select** – User selects sugar level.
4. **Temp Control** – Heater activates until temperature is reached.
5. **Dispensing** – Ingredients dispensed in sequence.
6. **Coffee Ready** – Buzzer alerts user.

---

## 🖥️ Simulation Snapshot

Simulation was carried out using a waveform viewer to verify the functioning of all signals, inputs, and output logic.

Key Signals:
- `flavour_select`, `sugar_select`, `temp_value`, `done`, `buzzer`
- Dispensers: `coffee_powder`, `water`, `milk_dispenser`, `syrup_dispenser`

---

## 🔧 How to Run

1. Use any Verilog simulator like **ModelSim**, **Vivado**, or **Icarus Verilog**.
2. Compile both `coffee.v` and `coffee_tb.v`.
3. Run the simulation.
4. Observe waveform outputs to verify correct operation.

---

## 📚 Skills Applied

- Digital System Design
- FSM Implementation
- Verilog HDL Programming
- Signal Timing Analysis
- Embedded System Basics
- Project Presentation & Visualization

---

## 🧠 Credits

Designed and implemented as part of an academic embedded systems/digital design project.

---

## 📌 Future Improvements

- Integrate real dispensers via motor drivers
- LCD Display for user interface
- Multiple beverage support with advanced menu
- Temperature feedback from real-time sensors

---

