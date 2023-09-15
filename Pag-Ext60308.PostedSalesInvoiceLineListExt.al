pageextension 60308 PostedSalesInvoiceLineListExt extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("Hardware Price"; Rec."Hardware Price")
            {
                ApplicationArea = All;
                Caption = 'Hardware Price';
            }
            field("Graphics Price"; Rec."Graphics Price")
            {
                ApplicationArea = All;
                Caption = 'Graphics Price';
            }
        }
    }
}
