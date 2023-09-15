pageextension 60307 OrbusGeneralJnlExt extends "General Journal"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
