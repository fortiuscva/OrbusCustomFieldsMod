pageextension 50100 ItemCardEx extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(IN_ExtendedDescription; rec.IN_ExtendedDescription)
            {
                ApplicationArea = All;
            }
        }
        addafter("Purchasing Code")
        {
            field(IN_Queue; rec.IN_Queue)
            {
                ApplicationArea = All;
            }
        }
    }
    var myInt: Integer;
}
