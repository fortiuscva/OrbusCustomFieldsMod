tableextension 60302 "Orbus.SalesInvoiceLine" extends "Sales Invoice Line"
{
    fields
    {
        field(60100; "Hardware Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60101; "Graphics Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
