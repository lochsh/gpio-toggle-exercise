MEMORY
{
  FLASH : ORIGIN = 0x08000000, LENGTH = 256K
  RAM   : ORIGIN = 0x20000000, LENGTH =  64K
}

ENTRY(main);

SECTIONS
{
  PROVIDE(_stack_start = ORIGIN(RAM) + LENGTH(RAM));

  .vector_table ORIGIN(FLASH) :
  {
    /* Initial Stack Pointer (SP) value */
    LONG(_stack_start);

    /* Reset vector */
    KEEP(*(.vector_table.reset_vector));
    __reset_vector = .;

    /* Exceptions */
    KEEP(*(.vector_table.exceptions));
    __eexceptions = .;

    /* Device specific interrupts */
    KEEP(*(.vector_table.interrupts));
  } > FLASH

  PROVIDE(_stext = ADDR(.vector_table) + SIZEOF(.vector_table));

  /* ### .text */
  .text _stext :
  {
    *(.text .text.*);
    . = ALIGN(4);
    __etext = .;
  } > FLASH
}
