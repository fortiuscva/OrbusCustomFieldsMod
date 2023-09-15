pageextension 60304 "ORBUS.CustomerPageExt" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Needs Magento ID"; Rec."Needs Magento ID")
            {
                ApplicationArea = All;
            }
            field("Last Visit Date"; Rec."Last Visit Date")
            {
                ApplicationArea = All;
            }
        }
        addlast(PostingDetails)
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
