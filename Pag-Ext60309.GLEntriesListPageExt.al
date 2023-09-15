pageextension 60309 GLEntriesListPageExt extends "General Ledger Entries"
{
    layout
    {
        addbefore("Global Dimension 1 Code")
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
                Caption = 'Location Code';
            }
        }
    }
}
