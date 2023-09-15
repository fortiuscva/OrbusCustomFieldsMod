pageextension 50103 SalesLinesEx extends "Sales Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 2 Code")
        {
            field(SystemCreatedAt; rec.SystemCreatedAt)
            {
                ApplicationArea = All;
            }
            field(SystemModifiedAt; rec.SystemModifiedAt)
            {
                ApplicationArea = All;
            }
        }
    }
    var myInt: Integer;
}
