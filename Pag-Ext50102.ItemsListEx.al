pageextension 50102 ItemsListEx extends "Item List"
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
    }
    var myInt: Integer;
}
