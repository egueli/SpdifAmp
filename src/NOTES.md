# Implementation notes

## VU meter

Requirements: 

* We have 10 LEDs
* The input signal is 16 to 20 bit wide
* The LEDs will illuminate like a bar depending on the maximum signal magnitude in the last X time period, where X must be lower than 20ms.
* Will measure the input signal, not the output after amplify & saturate.
* The highest LED will be on if the magnitude required the MSB bit (excl. sign), lower LEDs will use the most-significant bits accordingly
* The lowest LED will be on if the magnitude is anything than 0.

Chain in `vu_meter` entity:
1. `magnitude` entity: computes logarithm of absolute
    1. Signed sample (16bit) to absolute (16bit)
    1. Absolute (16bit) to magnitude (5bit, 0..16)
1. `max_window` entity
    * Reset every N clock pulses
        * Pro: doesn't require sync with input
        * Con: may require more LEs for prescaler
1. `ledbar` entity
    1. Magnitude (5bit, 0..16) to bar value (4bit, 0..10)
        * If 0 => 0
        * If 1 to 6 => 1
        * If 7 to 16 => magnitude - 6
    1. Bar value (4bit, 0..10) to led bar (10bit)

    
Other options considered:
* `max_window`:
    * Reset from external trigger
        * Can use occurrence of Z subframe
            * Once every 192 samples = 230 - 250 Hz
            * Pro: no need of clock prescaler
            * Con: no more updates if SPDIF bitstream stops e.g. TV turns off