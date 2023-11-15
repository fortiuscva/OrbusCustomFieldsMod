page 50102 "Dimension Set Tree Node"
{
    ApplicationArea = All;
    Caption = 'Dimension Set Tree Node';
    PageType = List;
    SourceTable = "Dimension Set Tree Node";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Parent Dimension Set ID"; Rec."Parent Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Parent Dimension Set ID field.';
                }
                field("Dimension Value ID"; Rec."Dimension Value ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Value ID field.';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }
                field("In Use"; Rec."In Use")
                {
                    ToolTip = 'Specifies the value of the In Use field.';
                }
            }
        }
    }
}
