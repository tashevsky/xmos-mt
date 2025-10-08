# CSR Generator Script

class CSRRegister:
    name: str
    rw: bool
    initial_value: int

    def __init__(self, name, rw, initial_value) -> None:
        self.name = name
        self.rw = rw
        self.initial_value = initial_value


def csr_initial_to_binstr(csr_init: int, csr_rw: bool) -> str:
    return bin(csr_init)[2:].zfill(32)


def csr_map_str_repr(csr: CSRRegister, addr: int) -> str:
    readmemb_init = csr_initial_to_binstr(csr.initial_value, csr.rw)
    readmemb_comment = f"{csr.name} "
    
    readmemb_comment += f"{hex(addr)}"

    csr_desc = f"{readmemb_init} // {readmemb_comment}\n"

    return csr_desc


def csr_prot_str_repr(csr: CSRRegister, addr: int) -> str:
    readmemb_init = str(int(csr.rw))
    readmemb_comment = f"{csr.name} "
    readmemb_comment += f"{hex(addr)}"
    csr_desc = f"{readmemb_init} {" " * 10} // {readmemb_comment}\n"
    return csr_desc


def csr_map_file_header() -> str:
    header = "// CSR Register Map\n"
    desc = f"// CSR_VALUE {" " * 22} CSR_DESC\n"
    return header + desc


def csr_prot_file_header() -> str:
    header = "// CSR Protection File\n"
    desc = f"// CSR_PROT_BIT SCR_DESC\n"
    return header + desc


def main(*args, **kwargs):
    RISCV_CSR_RANGE = 4096

    # name, RW_flag, initial_value: addr
    csr_register_set = {
        CSRRegister("misa", False, 0x1): 0x300,
        CSRRegister("mcycle", False, 0x0): 0xB00
    }

    # Dump
    with open("csr_map.txt", "w") as csr_map, \
        open("csr_protection.txt", "w") as csr_prot:

        csr_map.write(csr_map_file_header())
        csr_prot.write(csr_prot_file_header())

        # Process defined CSR registers
        csr_undef_reg = CSRRegister("undefined", True, 0x0)

        prev_addr, next_addr = 0, 0
        for csr_reg, csr_addr in csr_register_set.items():
            next_addr = csr_addr
            for addr in range(prev_addr, next_addr):
                csr_map.write(csr_map_str_repr(csr_undef_reg, addr))
                csr_prot.write(csr_prot_str_repr(csr_undef_reg, addr))
            
            csr_map.write(csr_map_str_repr(csr_reg, csr_addr))
            csr_prot.write(csr_prot_str_repr(csr_reg, csr_addr))

            prev_addr = next_addr + 1

        if prev_addr < RISCV_CSR_RANGE:
            for addr in range(prev_addr, RISCV_CSR_RANGE):
                csr_map.write(csr_map_str_repr(csr_undef_reg, addr))
                csr_prot.write(csr_prot_str_repr(csr_undef_reg, addr))
        

if __name__ == "__main__":
    main()
