const TK1_MMIO_BASE: usize             = 0xc0000000;
const TK1_MMIO_TK1_BASE: usize         = TK1_MMIO_BASE | 0x3f000000;
const TK1_MMIO_UART_BASE: usize        = TK1_MMIO_BASE | 0x03000000;

const LED: usize                        = TK1_MMIO_TK1_BASE | 0x24;

const UartTxData: usize                = TK1_MMIO_UART_BASE | 0x104;

const TK1_MMIO_TK1_LED_R_BIT: usize    = 2;
const TK1_MMIO_TK1_LED_G_BIT: usize    = 1;
const TK1_MMIO_TK1_LED_B_BIT: usize    = 0;

const uart_buf_reg: *i32 = @ptrFromInt(UartTxData);
const call_led: *i32 = @ptrFromInt(LED);


fn sleep(x: usize) void {
    var i: usize = 0;
    while (i < x) {
        i += 1;
        asm volatile ("nop");

    }
}

export fn main() noreturn {
    while (true) {
        call_led.* = 1 << TK1_MMIO_TK1_LED_R_BIT;
        sleep(100000);
        call_led.* = 1 << TK1_MMIO_TK1_LED_G_BIT;
        sleep(100000);
        call_led.* = 1 << TK1_MMIO_TK1_LED_B_BIT;
        sleep(100000);
    }
}
