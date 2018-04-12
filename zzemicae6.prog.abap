*&---------------------------------------------------------------------*
*& Report  zzemicae6
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zzemicae6.

DATA: ok_code   TYPE sy-ucomm,
      st_tdline TYPE tdline,
      it_tdline TYPE TABLE OF tdline,
      container TYPE REF TO cl_gui_custom_container,
      editor    TYPE REF TO cl_gui_textedit.

START-OF-SELECTION.

  CALL SCREEN 9001.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  SWITCH_EDIT_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM switch_edit_mode.

  IF editor->m_readonly_mode = 1.
    editor->set_readonly_mode( readonly_mode = 0 ).
  ELSE.
    editor->set_readonly_mode( readonly_mode = 1 ).
  ENDIF.

ENDFORM.                               " SWITCH_EDIT_MODE
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*

MODULE status_9001 OUTPUT.
  SET PF-STATUS 'DEFAULT'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_9001  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  CASE ok_code.
    WHEN 'EXEC'.
    WHEN 'SAVE'.
    WHEN 'SWITCH'.
      PERFORM switch_edit_mode.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'CANCEL' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_9001  INPUT

*&---------------------------------------------------------------------*
*&      Module  INITIALIZATION_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE initialization_9001 OUTPUT.

  IF container IS INITIAL AND editor IS INITIAL.
    CREATE OBJECT: container EXPORTING container_name = 'TEXTEDIT',
                   editor    EXPORTING parent           = container
                                       max_number_chars = 140
                                       wordwrap_mode    = 1.

    st_tdline = 'texto breve'.
    APPEND st_tdline TO it_tdline.

    editor->set_text_as_stream( text = it_tdline ).

    editor->set_toolbar_mode(
      EXPORTING
        toolbar_mode           = 0
      EXCEPTIONS
        error_cntl_call_method = 1
        invalid_parameter      = 2
        OTHERS                 = 3
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDMODULE.                 " INITIALIZATION_9001  OUTPUT
