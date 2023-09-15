pageextension 60303 "ORBUS.SalesInvoiceExt" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Qty. Assigned")
        {
            field("Qty. To Invoice"; Rec."Qty. To Invoice")
            {
                ApplicationArea = All;
            }
            field("Qty. To Ship"; Rec."Qty. To Ship")
            {
                ApplicationArea = All;
            }
            field("Quantity Shipped"; Rec."Quantity Shipped")
            {
                ApplicationArea = All;
            }
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
