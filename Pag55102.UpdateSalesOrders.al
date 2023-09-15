page 55102 UpdateSalesOrders
{
    ApplicationArea = All;
    Caption = 'Update Sales Orders';
    UsageCategory = Tasks;
    PageType = Card;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(SalesOrderNo; SalesOrderNo)
            {
                ApplicationArea = All;
                Caption = 'Sales Order No.';

                trigger OnValidate()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("No.", SalesOrderNo);
                    if SalesHeader.FindFirst()then begin
                        SalesHeader."Order Status":=SalesHeader."Order Status"::"AC In Production";
                        SalesHeader."Production Scan Time":=CurrentDateTime();
                        SalesHeader.Modify();
                        SuccessfullyUpdated:=SuccessfullyUpdated::Yes;
                        LastScanSONo:=SalesOrderNo;
                        SalesOrderNo:='';
                    end
                    else
                    begin
                        Message('No record in sales header table exists with value of: %1', SalesOrderNo);
                        LastScanSONo:=SalesOrderNo;
                        SalesOrderNo:='';
                        SuccessfullyUpdated:=SuccessfullyUpdated::No;
                    end;
                end;
            }
            field(SuccessfullyUpdated; SuccessfullyUpdated)
            {
                ApplicationArea = All;
                Caption = 'Successfully Updated';
                Editable = false;
            }
            field(LastScanSONo; LastScanSONo)
            {
                ApplicationArea = ALl;
                Caption = 'Last Scan (SO No.)';
                Editable = false;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        SuccessfullyUpdated:=SuccessfullyUpdated::" ";
    end;
    var SalesOrderNo: Code[20];
    SuccessfullyUpdated: Option " ", Yes, No;
    ProductionScanTime: DateTime;
    LastScanSONo: Text;
}
