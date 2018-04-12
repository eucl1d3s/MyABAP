*&---------------------------------------------------------------------*
*& Report  zzemicae7
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zzemicae7.

START-OF-SELECTION.

  SELECT * FROM sflight INTO TABLE @DATA(gt_sflight) UP TO 100 ROWS.
  IF lines( gt_sflight ) GT 0.
    LOOP AT gt_sflight ASSIGNING FIELD-SYMBOL(<fs_sflight>).

    ENDLOOP.
  ENDIF.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = DATA(lo_alv)
        CHANGING  t_table      = gt_sflight
      ).
    CATCH cx_salv_msg INTO DATA(lx_msg).
      MESSAGE lx_msg TYPE 'E'.
  ENDTRY.

  lo_alv->display( ).
