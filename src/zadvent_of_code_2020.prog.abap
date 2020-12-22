*&---------------------------------------------------------------------*
*& Report zadvent_of_code_2020
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zadvent_of_code_2020.

PARAMETERS p_fldr TYPE string LOWER CASE DEFAULT `C:\Users\chris\Documents\Advent of Code\2020`.

CLASS read_file_exception DEFINITION INHERITING FROM cx_dynamic_check.
ENDCLASS.

CLASS app DEFINITION.
  PUBLIC SECTION.
    METHODS run.
  PRIVATE SECTION.
    TYPES: file_content TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    TYPES: int_tab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS puzzle_1a
      IMPORTING
        i_input TYPE int_tab.
    METHODS puzzle_1b
      IMPORTING
        i_input TYPE int_tab.
    METHODS read_file
      IMPORTING
        i_filename            TYPE string
      RETURNING
        VALUE(r_file_content) TYPE file_content.
    METHODS read_int_file
      IMPORTING
        i_filename       TYPE string
      RETURNING
        VALUE(r_int_tab) TYPE  int_tab.
ENDCLASS.

NEW app( )->run( ).

CLASS app IMPLEMENTATION.

  METHOD run.
    WRITE p_fldr.
    DATA(puzzle1_input) = read_int_file( `input1.txt` ).
    puzzle_1a( puzzle1_input ).
    puzzle_1b( puzzle1_input ).
  ENDMETHOD.

  METHOD puzzle_1a.
    LOOP AT i_input REFERENCE INTO DATA(value1).
      LOOP AT i_input REFERENCE INTO DATA(value2).
        IF value1->* + value2->* = 2020.
          WRITE: / 'Puzzle 1 a:', |{ value1->* * value2->* }|.
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD puzzle_1b.
    LOOP AT i_input REFERENCE INTO DATA(value1).
      LOOP AT i_input REFERENCE INTO DATA(value2).
        LOOP AT i_input REFERENCE INTO DATA(value3).
          IF value1->* + value2->* + value3->* = 2020.
            WRITE: / 'Puzzle 1 b:', |{ value1->* * value2->* * value3->* }|.
            RETURN.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD read_file.

    cl_gui_frontend_services=>gui_upload(
      EXPORTING
        filename                = p_fldr && `\` && i_filename
      CHANGING
        data_tab                =                  r_file_content
      EXCEPTIONS
        file_open_error         = 1                " File does not exist and cannot be opened
        file_read_error         = 2                " Error when reading file
        no_batch                = 3                " Cannot execute front-end function in background
        gui_refuse_filetransfer = 4                " Incorrect front end or error on front end
        invalid_type            = 5                " Incorrect parameter FILETYPE
        no_authority            = 6                " No upload authorization
        unknown_error           = 7                " Unknown error
        bad_data_format         = 8                " Cannot Interpret Data in File
        header_not_allowed      = 9                " Invalid header
        separator_not_allowed   = 10               " Invalid separator
        header_too_long         = 11               " Header information currently restricted to 1023 bytes
        unknown_dp_error        = 12               " Error when calling data provider
        access_denied           = 13               " Access to File Denied
        dp_out_of_memory        = 14               " Not enough memory in data provider
        disk_full               = 15               " Storage medium is full.
        dp_timeout              = 16               " Data provider timeout
        not_supported_by_gui    = 17               " GUI does not support this
        error_no_gui            = 18               " GUI not available
        OTHERS                  = 19
    ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE read_file_exception.
    ENDIF.

  ENDMETHOD.

  METHOD read_int_file.
    DATA(file_content) = read_file( i_filename ).
    r_int_tab = file_content.
  ENDMETHOD.

ENDCLASS.
