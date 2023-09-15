pageextension 60306 "Orbus.SalesInvoiceSubformExt" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Hardware Price"; Rec."Hardware Price")
            {
                ApplicationArea = All;
            }
            field("Graphics Price"; Rec."Graphics Price")
            {
                ApplicationArea = All;
            }
        }
    }
}
