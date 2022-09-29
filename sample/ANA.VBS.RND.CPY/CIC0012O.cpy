       01 CIC0012O-REC.
          02 CIC0012O-CUST-REC.
            05 CIC0012O-NAME            PIC X(30).
            05 CIC0012O-ENGLISH-NAME    PIC X(40).
            05 CIC0012O-NATIONALITY     PIC X(20).
            05 CIC0012O-BIRTH-DATE      PIC X(10).
            05 CIC0012O-GENDER          PIC X(01).
            05 CIC0012O-MARITAL-STATUS  PIC X(01).
            05 CIC0012O-CUST-ID-TYPE     PIC 9(03).
            05 CIC0012O-CUST-ID-NUMBER   PIC X(18).
            05 CIC0012O-ANNUAL-SALARY   PIC 9(08).
            05 CIC0012O-MOBILE          PIC 9(11).
            05 CIC0012O-EMAIL           PIC X(40).
            05 CIC0012O-BILL-TYPE       PIC 9(03).
            05 CIC0012O-BILL-ADDR       PIC 9(03).
            05 CIC0012O-BILL-DATE       PIC 9(02).
            05 CIC0012O-APP-DATE        PIC X(10).
            05 CIC0012O-LIVE-COUNTRY    PIC X(20).
            05 CIC0012O-LIVE-PROVINCE   PIC X(20).
            05 CIC0012O-LIVE-CITY       PIC X(20).
            05 CIC0012O-LIVE-DISTRICT   PIC X(20).
            05 CIC0012O-LIVE-ZIP-CODE   PIC 9(06).
            05 CIC0012O-LIVE-ADDRESS    PIC X(40).
            05 CIC0012O-LIVE-YEARS      PIC 9(03).
            05 CIC0012O-COMPANY-NAME    PIC X(40).
            05 CIC0012O-COMPANY-COUNTRY PIC X(20).
            05 CIC0012O-COMPANY-PROVINCE PIC X(20).
            05 CIC0012O-COMPANY-CITY    PIC X(20).
            05 CIC0012O-COMPANY-DISTRICT PIC X(20).
            05 CIC0012O-COMPANY-ZIP-CODE PIC 9(06).
            05 CIC0012O-COMPANY-ADRESS  PIC X(40).
            05 CIC0012O-COMPANY-SERVE-YEAR PIC 9(03).
          02 CIC0012O-APPL-REC.
            05 CIC0012O-ID                 PIC 9(13).
            05 CIC0012O-IN-DATE            PIC X(10).
            05 CIC0012O-IN-TIME            PIC X(05).
            05 CIC0012O-STATUS             PIC 9(03).
            05 CIC0012O-ID-TYPE            PIC 9(03).
            05 CIC0012O-ID-NUMBER          PIC X(18).
            05 CIC0012O-LAST-DATE          PIC X(10).
            05 CIC0012O-LAST-TIME          PIC X(05).
            05 CIC0012O-INTCHK-ID          PIC X(08).
            05 CIC0012O-INTCHK-DATE        PIC X(10).
            05 CIC0012O-INTCHK-RESULT      PIC 9(03).
            05 CIC0012O-INTCHK-REFUSE-REASON PIC 9(03).
            05 CIC0012O-INTCHK-COMMENT     PIC X(60).
            05 CIC0012O-REVIEW-ID          PIC X(08).
            05 CIC0012O-REVIEW-DATE        PIC X(10).
            05 CIC0012O-REVIEW-RESULT      PIC 9(03).
            05 CIC0012O-REVIEW-REFUSE-REASON PIC 9(03).
            05 CIC0012O-REVIEW-COMMENT     PIC X(60).
            05 CIC0012O-CREINV-ID          PIC X(08).
            05 CIC0012O-CREINV-DATE        PIC X(10).
            05 CIC0012O-CREINV-RESULT      PIC X(03).
            05 CIC0012O-CREINV-REFUSE-REASON PIC X(03).
            05 CIC0012O-CREINV-COMMENT     PIC X(60).
            05 CIC0012O-ACCT-COUNT         PIC 9(03).
            05 CIC0012O-CREDIT-HISTORY     PIC 9(03).
            05 CIC0012O-CREDIT-HOLD        PIC 9(03).
            05 CIC0012O-MANCRE-ID          PIC X(08).
            05 CIC0012O-MANCRE-DATE        PIC X(10).
            05 CIC0012O-MANCRE-RESULT      PIC 9(03).
            05 CIC0012O-MANCRE-REFUSE-REASON PIC X(03).
            05 CIC0012O-MANCRE-COMMENT     PIC X(60).
            05 CIC0012O-COMPUTE-LIMIT      PIC 9(08).
            05 CIC0012O-COMPUTE-RESULT     PIC 9(03).
            05 CIC0012O-COMPUTE-REFUSE-REASON PIC 9(03).
            05 CIC0012O-FINAL-LIMIT        PIC 9(08).
