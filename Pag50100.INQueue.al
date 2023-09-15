page 50100 "IN_Queue"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = IN_Queue;
    Caption = 'Queue';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(IN_Code; Rec.IN_Code)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                end;
            }
        }
    }
    var myInt: Integer;
}
