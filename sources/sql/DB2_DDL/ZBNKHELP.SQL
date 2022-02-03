DROP TABLE BNKHELP;
COMMIT;

CREATE TABLE BNKHELP
(
    BHP_SCRN               CHAR(6) NOT NULL,
    BHP_LINE               CHAR(2) NOT NULL,
    BHP_TEXT               CHAR(75) NOT NULL
);
--IN DATABASE DBNASE
--AUDIT NONE
--DATA CAPTURE NONE;

CREATE UNIQUE INDEX BNKHELP_IDX1 ON BNKHELP
(
     BHP_SCRN,
     BHP_LINE
);

INSERT INTO BNKHELP VALUES ('BANK10','01',
'This is the help for screen BANK10.                                        ');
INSERT INTO BNKHELP VALUES ('BANK10','03',
'Your user id is used to identify you to the application and will determine ');
INSERT INTO BNKHELP VALUES ('BANK10','04',
'what you are allowed to do.                                                ');
INSERT INTO BNKHELP VALUES ('BANK10','06',
'Valid user ids are:                                                        ');
INSERT INTO BNKHELP VALUES ('BANK10','07',
'  B0001 thru B0036, or GUEST (B0004 shows well, GUEST is limited)          ');
INSERT INTO BNKHELP VALUES ('BANK10','09',
'Valid password is any set of non-blank characters.                         ');
INSERT INTO BNKHELP VALUES ('BANK10','11',
'While on screen BANK10, you may use F2 to swap between a colour screen     ');
INSERT INTO BNKHELP VALUES ('BANK10','12',
'and mono-chrome (green on black).                                          ');
INSERT INTO BNKHELP VALUES ('BANK10','14',
'Changing the B to Z will give the users as B but has an extra option       ');
INSERT INTO BNKHELP VALUES ('BANK10','15',
'available to generate error situations.                                    ');
INSERT INTO BNKHELP VALUES ('BANK10','19',
'From here, use F3 to exit the application or F4 to return to screen BANK10 ');

INSERT INTO BNKHELP VALUES ('BANK20','01',
'This is the help for screen BANK20.                                        ');
INSERT INTO BNKHELP VALUES ('BANK20','03',
'Depending on your personal sign-on status, you may:                        ');
INSERT INTO BNKHELP VALUES ('BANK20','05',
'a) display a list of your accounts with their current balances.            ');
INSERT INTO BNKHELP VALUES ('BANK20','07',
'b) transfer funds between accounts.                                        ');
INSERT INTO BNKHELP VALUES ('BANK20','09',
'c) update your contact information, eg your address and phone number.      ');
INSERT INTO BNKHELP VALUES ('BANK20','11',
'd) request the cost of a loan                                              ');
INSERT INTO BNKHELP VALUES ('BANK20','13',
' OR                                                                        ');
INSERT INTO BNKHELP VALUES ('BANK20','15',
'e) obtain additional information on our products and services              ');
INSERT INTO BNKHELP VALUES ('BANK20','19',
'From here, use F3 to exit the application or F4 to return to screen BANK20 ');

INSERT INTO BNKHELP VALUES ('BANK30','01',
'This is the help for screen BANK30.                                        ');
INSERT INTO BNKHELP VALUES ('BANK30','03',
'You have requested a list of your accounts and their balances.             ');
INSERT INTO BNKHELP VALUES ('BANK30','05',
'Details shown are:                                                         ');
INSERT INTO BNKHELP VALUES ('BANK30','06',
'- the account number                                                       ');
INSERT INTO BNKHELP VALUES ('BANK30','07',
'- the type of account                                                      ');
INSERT INTO BNKHELP VALUES ('BANK30','08',
'- the current balance of that account                                      ');
INSERT INTO BNKHELP VALUES ('BANK30','09',
'- any service charge that will be applied.                                 ');
INSERT INTO BNKHELP VALUES ('BANK30','10',
'  (based on the account"s current balance)                                 ');
INSERT INTO BNKHELP VALUES ('BANK30','11',
'- the date of the last statement                                           ');
INSERT INTO BNKHELP VALUES ('BANK30','12',
'- indicator to show if transaction details are available                   ');
INSERT INTO BNKHELP VALUES ('BANK30','19',
'From here, use F3 to exit the application or F4 to return to screen BANK30 ');

INSERT INTO BNKHELP VALUES ('BANK40','01',
'This is the help for screen BANK40.                                        ');
INSERT INTO BNKHELP VALUES ('BANK40','03',
'You have requested the transaction details for a selected account.         ');
INSERT INTO BNKHELP VALUES ('BANK40','05',
'Details shown are:                                                         ');
INSERT INTO BNKHELP VALUES ('BANK40','06',
'- the date the transaction was actioned                                    ');
INSERT INTO BNKHELP VALUES ('BANK40','07',
'- the time the transaction was actioned                                    ');
INSERT INTO BNKHELP VALUES ('BANK40','08',
'- the amount of the transaction                                            ');
INSERT INTO BNKHELP VALUES ('BANK40','09',
'- any description associated with the transaction                          ');
INSERT INTO BNKHELP VALUES ('BANK40','11',
'If there are more transactions than will fit on one screen then you will be');
INSERT INTO BNKHELP VALUES ('BANK40','12',
'able to page through them using F7 and/or F8 as indicated.                 ');
INSERT INTO BNKHELP VALUES ('BANK40','19',
'From here, use F3 to exit the application or F4 to return to screen BANK40 ');

INSERT INTO BNKHELP VALUES ('BANK50','01',
'This is the help for screen BANK50.                                        ');
INSERT INTO BNKHELP VALUES ('BANK50','03',
'You wish to transfer funds between two of your accounts.                   ');
INSERT INTO BNKHELP VALUES ('BANK50','05',
'Please enter the amount you wish to transfer (a dollar && cent value).     ');
INSERT INTO BNKHELP VALUES ('BANK50','07',
'Next indicate the account you wish to transfer the funds from and to.      ');
INSERT INTO BNKHELP VALUES ('BANK50','19',
'From here, use F3 to exit the application or F4 to return to screen BANK50 ');

INSERT INTO BNKHELP VALUES ('BANK60','01',
'This is the help for screen BANK60.                                        ');
INSERT INTO BNKHELP VALUES ('BANK60','03',
'You have selected to update your contact information.                      ');
INSERT INTO BNKHELP VALUES ('BANK60','05',
'To change the information, type over the existing information.             ');
INSERT INTO BNKHELP VALUES ('BANK60','06',
'If a line is no longer required, type spaces over the existing information.');
INSERT INTO BNKHELP VALUES ('BANK60','07',
'Press <Enter> when you have finished. The revised information will be      ');
INSERT INTO BNKHELP VALUES ('BANK60','08',
'redisplayed and you will be asked to confirm that it is correct by pressing');
INSERT INTO BNKHELP VALUES ('BANK60','09',
'PFK10. At that point, any other key will take you back to the existing     ');
INSERT INTO BNKHELP VALUES ('BANK60','10',
'information.                                                               ');
INSERT INTO BNKHELP VALUES ('BANK60','19',
'From here, use F3 to exit the application or F4 to return to screen BANK60 ');

INSERT INTO BNKHELP VALUES ('BANK70','01',
'This is the help for screen BANK70.                                        ');
INSERT INTO BNKHELP VALUES ('BANK70','03',
'You have selected to calulate the cost of a loan.                          ');
INSERT INTO BNKHELP VALUES ('BANK70','05',
'Enter:                                                                     ');
INSERT INTO BNKHELP VALUES ('BANK70','06',
'- the amount you wish to borrow                                            ');
INSERT INTO BNKHELP VALUES ('BANK70','07',
'- the interest rate as a percentage, eg 2.50                               ');
INSERT INTO BNKHELP VALUES ('BANK70','08',
'- the repayment term as the number of months, eg 12                        ');
INSERT INTO BNKHELP VALUES ('BANK70','10',
'Press <Enter> to see the monthly repayment                                 ');
INSERT INTO BNKHELP VALUES ('BANK70','19',
'From here, use F3 to exit the application or F4 to return to screen BANK20 ');

INSERT INTO BNKHELP VALUES ('BANK80','01',
'This is the help for screen BANK80.                                        ');
INSERT INTO BNKHELP VALUES ('BANK80','03',
'You have selected to request a printed statement.                          ');
INSERT INTO BNKHELP VALUES ('BANK80','05',
'If you have an e-mail address of file you will be given the choice of      ');
INSERT INTO BNKHELP VALUES ('BANK80','06',
'having it sent to you via regualar mail or e-mail.                         ');
INSERT INTO BNKHELP VALUES ('BANK80','08',
'Once a choice has been made, or no choice if no email, you will be         ');
INSERT INTO BNKHELP VALUES ('BANK80','09',
'prompted to press PFK10 to confirm the request.                            ');
INSERT INTO BNKHELP VALUES ('BANK80','10',
'Pressing PFK10 will also retun you to screen BANK20 with a message         ');
INSERT INTO BNKHELP VALUES ('BANK80','11',
'informing you of if the request was successful.                            ');
INSERT INTO BNKHELP VALUES ('BANK80','19',
'From here, use F3 to exit the application or F4 to return to screen BANK20 ');

INSERT INTO BNKHELP VALUES ('BANK90','01',
'This is the help for screen BANK90.                                        ');
INSERT INTO BNKHELP VALUES ('BANK90','03',
'You have requested additional information.                                 ');
INSERT INTO BNKHELP VALUES ('BANK90','19',
'From here, use F3 to exit the application or F4 to return to screen BANK20 ');

INSERT INTO BNKHELP VALUES ('BANKZZ','01',
'This is the help for screen BANKZZ.                                        ');
INSERT INTO BNKHELP VALUES ('BANKZZ','03',
'You have the choice of a number of selections.                             ');
INSERT INTO BNKHELP VALUES ('BANKZZ','05',
'Each selection will generate a different error condition which may be      ');
INSERT INTO BNKHELP VALUES ('BANKZZ','06',
'used to demonstrate how errors are handled and debugging performed.        ');
INSERT INTO BNKHELP VALUES ('BANKZZ','19',
'From here, use F3 to exit the application or F4 to return to screen BANKZZ ');

INSERT INTO BNKHELP VALUES ('DEMO10','01',
'This is the help for screen DEMO10.                                        ');
INSERT INTO BNKHELP VALUES ('DEMO10','03',
'Please select one of the options shown on the menu and press enter         ');
INSERT INTO BNKHELP VALUES ('DEMO10','10',
'While on screen DEMO10, you may use F2 to swap between a colour screen     ');
INSERT INTO BNKHELP VALUES ('DEMO10','11',
'and mono-chrome (green on black).                                          ');
INSERT INTO BNKHELP VALUES ('DEMO10','19',
'From here, use F3 to exit the application or F4 to return to screen DEMO10 ');
INSERT INTO BNKHELP VALUES ('INSC01','01',
'This is the help for screen INSC01.                                        ');
INSERT INTO BNKHELP VALUES ('INSC01','03',
'Your user id is used to identify you to the application and will determine ');
INSERT INTO BNKHELP VALUES ('INSC01','04',
'what you are allowed to do.                                                ');
INSERT INTO BNKHELP VALUES ('INSC01','06',
'Valid user ids are:                                                        ');
INSERT INTO BNKHELP VALUES ('INSC01','07',
'  00001 - 00030 (normal individuals)                                       ');
INSERT INTO BNKHELP VALUES ('INSC01','08',
'  00101 - 00106 (individuals who are also agents)                          ');
INSERT INTO BNKHELP VALUES ('INSC01','10',
'Valid password is any set of non-blank characters.                         ');
INSERT INTO BNKHELP VALUES ('INSC01','12',
'While on screen INSC01, you may use F2 to swap between a colour screen     ');
INSERT INTO BNKHELP VALUES ('INSC01','13',
'and mono-chrome (green on black).                                          ');
INSERT INTO BNKHELP VALUES ('INSC01','19',
'From here, use F3 to exit the application or F4 to return to screen INSC01 ');
INSERT INTO BNKHELP VALUES ('INSC02','01',
'This is the help for screen INSC02.                                        ');
INSERT INTO BNKHELP VALUES ('INSC02','03',
'The user id you entered indicated that you are also an insurance agent.    ');
INSERT INTO BNKHELP VALUES ('INSC02','05',
'You have the choice of:                                                    ');
INSERT INTO BNKHELP VALUES ('INSC02','06',
'a) working as an agent. In this instance you will be given access to all   ');
INSERT INTO BNKHELP VALUES ('INSC02','07',
'   policies that are associated with your agency.                          ');
INSERT INTO BNKHELP VALUES ('INSC02','08',
' OR                                                                        ');
INSERT INTO BNKHELP VALUES ('INSC02','09',
'b) working as an individual. In this instance you only have access to your ');
INSERT INTO BNKHELP VALUES ('INSC02','10',
'   own policies.                                                           ');
INSERT INTO BNKHELP VALUES ('INSC02','19',
'From here, use F3 to exit the application or F4 to return to screen INSC02 ');
INSERT INTO BNKHELP VALUES ('INSC10','01',
'This is the help for screen INSC10.                                        ');
INSERT INTO BNKHELP VALUES ('INSC10','03',
'You have selected to work as an insurance agent.                           ');
INSERT INTO BNKHELP VALUES ('INSC10','05',
'You have four options:                                                     ');
INSERT INTO BNKHELP VALUES ('INSC10','06',
'a) to ask for a list of the policies associated with your agency and you wi');
INSERT INTO BNKHELP VALUES ('INSC10','07',
'   be able to select cases from the list to work with                      ');
INSERT INTO BNKHELP VALUES ('INSC10','09',
'b) input the policy number directly (it will be checked to ensure that it d');
INSERT INTO BNKHELP VALUES ('INSC10','10',
'   belong to your agency).                                                 ');
INSERT INTO BNKHELP VALUES ('INSC10','12',
'c) to ask for a list of claims associated with your agency and you will    ');
INSERT INTO BNKHELP VALUES ('INSC10','13',
'   be able to select cases from the list to work with                      ');
INSERT INTO BNKHELP VALUES ('INSC10','15',
'd) input the claim number directly (it will be checked to ensure that it do');
INSERT INTO BNKHELP VALUES ('INSC10','16',
'   belong to your agency).                                                 ');
INSERT INTO BNKHELP VALUES ('INSC10','19',
'From here, use F3 to exit the application or F4 to return to screen INSC10 ');
INSERT INTO BNKHELP VALUES ('INSC11','01',
'This is the help for screen INSC11.                                        ');
INSERT INTO BNKHELP VALUES ('INSC11','03',
'You have selected to work as an insurance agent and have requested a list  ');
INSERT INTO BNKHELP VALUES ('INSC11','04',
'of policies that are associated with your agency.                          ');
INSERT INTO BNKHELP VALUES ('INSC11','06',
'To select a policy, enter any non-blank character against it.              ');
INSERT INTO BNKHELP VALUES ('INSC11','08',
'If you press ENTER you will obtain the details of that policy.             ');
INSERT INTO BNKHELP VALUES ('INSC11','09',
'If there are any claims for the selected policy, pressing F10 will show the');
INSERT INTO BNKHELP VALUES ('INSC11','11',
'If there are more policies than will fit on the screen, F8 will appear     ');
INSERT INTO BNKHELP VALUES ('INSC11','12',
'as an option at the bottom of the screen which will page you forward to the');
INSERT INTO BNKHELP VALUES ('INSC11','13',
'next screen. Similarly, if you paged forward, F7 will appear as an option  ');
INSERT INTO BNKHELP VALUES ('INSC11','14',
'which will page you backwards to the previous screen.                      ');
INSERT INTO BNKHELP VALUES ('INSC11','19',
'From here, use F3 to exit the application or F4 to return to screen INSC11 ');
INSERT INTO BNKHELP VALUES ('INSC12','01',
'This is the help for screen INSC12.                                        ');
INSERT INTO BNKHELP VALUES ('INSC12','03',
'You have selected to work as an insurance agent and have details of one of ');
INSERT INTO BNKHELP VALUES ('INSC12','04',
'policies that is associated with your agency.                              ');
INSERT INTO BNKHELP VALUES ('INSC12','06',
'The following details are shown:                                           ');
INSERT INTO BNKHELP VALUES ('INSC12','07',
'- the policy number and type of coverage                                   ');
INSERT INTO BNKHELP VALUES ('INSC12','08',
'- the name, address and telephone number of the insured                    ');
INSERT INTO BNKHELP VALUES ('INSC12','09',
'- the date the policy was issued                                           ');
INSERT INTO BNKHELP VALUES ('INSC12','10',
'- the renewal date of the policy                                           ');
INSERT INTO BNKHELP VALUES ('INSC12','11',
'- the annual premium                                                       ');
INSERT INTO BNKHELP VALUES ('INSC12','12',
'- the frequency and amounts by which premiums are due                      ');
INSERT INTO BNKHELP VALUES ('INSC12','19',
'From here, use F3 to exit the application or F4 to return to screen INSC12 ');
INSERT INTO BNKHELP VALUES ('INSC20','01',
'This is the help for screen INSC20.                                        ');
INSERT INTO BNKHELP VALUES ('INSC20','03',
'You have selected to work as an individual policy holder.                  ');
INSERT INTO BNKHELP VALUES ('INSC20','05',
'You have two options:                                                      ');
INSERT INTO BNKHELP VALUES ('INSC20','06',
'a) to ask for a list of your policies and you will be able to select       ');
INSERT INTO BNKHELP VALUES ('INSC20','07',
'   which one you wish to see more details of                               ');
INSERT INTO BNKHELP VALUES ('INSC20','09',
'b) to ask for a list of your claims and you will be able to select         ');
INSERT INTO BNKHELP VALUES ('INSC20','10',
'   which one you wish to see more details of                               ');
INSERT INTO BNKHELP VALUES ('INSC20','19',
'From here, use F3 to exit the application or F4 to return to screen INSC20 ');
INSERT INTO BNKHELP VALUES ('INSC21','01',
'This is the help for screen INSC21.                                        ');
INSERT INTO BNKHELP VALUES ('INSC21','03',
'You have a list of your insurance policies.                                ');
INSERT INTO BNKHELP VALUES ('INSC21','05',
'To select a policy, enter any non-blank character against it and press ente');
INSERT INTO BNKHELP VALUES ('INSC21','06',
'If there are more entries than will fit on a screen then you will see F8 as');
INSERT INTO BNKHELP VALUES ('INSC21','07',
'an option at the bottom of the screen. Similarly, if you paged forward,    ');
INSERT INTO BNKHELP VALUES ('INSC21','08',
'F7 will appear as an option which will page you backwards to the previous  ');
INSERT INTO BNKHELP VALUES ('INSC21','09',
'screen.                                                                    ');
INSERT INTO BNKHELP VALUES ('INSC21','19',
'From here, use F3 to exit the application or F4 to return to screen INSC21 ');
INSERT INTO BNKHELP VALUES ('INSC22','01',
'This is the help for screen INSC22.                                        ');
INSERT INTO BNKHELP VALUES ('INSC22','03',
'You have selected to work with one of your insurance policies              ');
INSERT INTO BNKHELP VALUES ('INSC22','05',
'The following details are shown:                                           ');
INSERT INTO BNKHELP VALUES ('INSC22','06',
'- the policy number and type of coverage                                   ');
INSERT INTO BNKHELP VALUES ('INSC22','07',
'- the date the policy was issued                                           ');
INSERT INTO BNKHELP VALUES ('INSC22','08',
'- the renewal date of the policy (if any)                                  ');
INSERT INTO BNKHELP VALUES ('INSC22','09',
'- the maturity date of the policy                                          ');
INSERT INTO BNKHELP VALUES ('INSC22','10',
'- the term (duration) of the policy                                        ');
INSERT INTO BNKHELP VALUES ('INSC22','11',
'- the annual premium                                                       ');
INSERT INTO BNKHELP VALUES ('INSC22','12',
'- the frequency and amounts by which premiums are due                      ');
INSERT INTO BNKHELP VALUES ('INSC22','19',
'From here, use F3 to exit the application or F4 to return to screen INSC22 ');
INSERT INTO BNKHELP VALUES ('INSC30','01',
'This is the help for screen INSC30.                                        ');
INSERT INTO BNKHELP VALUES ('INSC30','03',
'You have selected to update an address.                                    ');
INSERT INTO BNKHELP VALUES ('INSC30','05',
'To change the information, type over the information under New Information.');
INSERT INTO BNKHELP VALUES ('INSC30','06',
'If a line is no longer required, type spaces over the data already there.  ');
INSERT INTO BNKHELP VALUES ('INSC30','07',
'Press <Enter> when you have finished. The revised information will be      ');
INSERT INTO BNKHELP VALUES ('INSC30','08',
'redisplayed and you will be asked to confirm that it is correct by pressing');
INSERT INTO BNKHELP VALUES ('INSC30','09',
'PFK10. At that point, any other key will take you back to the existing     ');
INSERT INTO BNKHELP VALUES ('INSC30','10',
'information.                                                               ');
INSERT INTO BNKHELP VALUES ('INSC30','19',
'From here, use F3 to exit the application or F4 to return to screen INSC30 ');
INSERT INTO BNKHELP VALUES ('INSC40','01',
'This is the help for screen INSC40.                                        ');
INSERT INTO BNKHELP VALUES ('INSC40','03',
'You have a list of claims.                                                 ');
INSERT INTO BNKHELP VALUES ('INSC40','05',
'To select a policy, enter any non-blank character against it and press ente');
INSERT INTO BNKHELP VALUES ('INSC40','06',
'If there are more entries than will fit on a screen then you will see F8 as');
INSERT INTO BNKHELP VALUES ('INSC40','07',
'as an option at the bottom of the screen. Similarly, if you paged forward, ');
INSERT INTO BNKHELP VALUES ('INSC40','08',
'F7 will appear as an option which will page you backwards to the previous  ');
INSERT INTO BNKHELP VALUES ('INSC40','09',
'screen.                                                                    ');
INSERT INTO BNKHELP VALUES ('INSC40','19',
'From here, use F3 to exit the application or F4 to return to screen INSC40 ');
INSERT INTO BNKHELP VALUES ('INSC41','01',
'This is the help for screen INSC41.                                        ');
INSERT INTO BNKHELP VALUES ('INSC41','03',
'You have a list of claims.                                                 ');
INSERT INTO BNKHELP VALUES ('INSC41','05',
'To select a policy a policy, enter any non-blank character against it and  ');
INSERT INTO BNKHELP VALUES ('INSC41','06',
'press enter. If there are more entries than will fit on a screen then you  ');
INSERT INTO BNKHELP VALUES ('INSC41','07',
'will see F8 as an option at the botom of the screen. Similarly, if you page');
INSERT INTO BNKHELP VALUES ('INSC41','08',
'forward, F7 will appear as an option which will page you backwards to the  ');
INSERT INTO BNKHELP VALUES ('INSC41','09',
'previous screen.                                                           ');
INSERT INTO BNKHELP VALUES ('INSC41','19',
'From here, use F3 to exit the application or F4 to return to screen INSC41 ');
INSERT INTO BNKHELP VALUES ('INSC42','01',
'This is the help for screen INSC42.                                        ');
INSERT INTO BNKHELP VALUES ('INSC42','03',
'Ultimately this screen (INSC42) will show details of a selected claim.     ');
INSERT INTO BNKHELP VALUES ('INSC42','05',
'Right now only the top part of the screen is populated as not all the      ');
INSERT INTO BNKHELP VALUES ('INSC42','06',
'necessary test data has been created.                                      ');
INSERT INTO BNKHELP VALUES ('INSC42','19',
'From here, use F3 to exit the application or F4 to return to screen INSC42 ');
INSERT INTO BNKHELP VALUES ('PRDA10','01',
'This is the help for screen PRDA10.                                        ');
INSERT INTO BNKHELP VALUES ('PRDA10','03',
'Please select one of the options shown on the menu and press enter         ');
INSERT INTO BNKHELP VALUES ('PRDA10','10',
'While on screen PRDA10, you may use F2 to swap between a colour screen     ');
INSERT INTO BNKHELP VALUES ('PRDA10','11',
'and mono-chrome (green on black).                                          ');
INSERT INTO BNKHELP VALUES ('PRDA10','19',
'From here, use F3 to exit the application or F4 to return to screen PRDA10 ');
INSERT INTO BNKHELP VALUES ('PRDA20','01',
'This is the help for screen PRDA20.                                        ');
INSERT INTO BNKHELP VALUES ('PRDA20','03',
'Sorry. No further help is available.                                       ');
INSERT INTO BNKHELP VALUES ('PRDA20','19',
'From here, use F3 to exit the application or F4 to return to screen PRDA20 ');
COMMIT;