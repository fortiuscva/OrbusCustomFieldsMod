page 50102 "Dimension Set Tree Node"
{
    ApplicationArea = All;
    Caption = 'Dimension Set Tree Node';
    PageType = List;
    SourceTable = "Dimension Set Tree Node";
    UsageCategory = Tasks;
    Editable = true;
    Permissions = tabledata 481 = RIMD;

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

    actions
    {
        area(Processing)
        {
            action(TransfertoTemp)
            {
                Caption = 'Transfer to Temp';
                ApplicationArea = all;
                trigger OnAction()
                Var
                    ORBDimensionSetTreeNode: Record "ORB Dimension Set Tree Node";
                begin
                    if not Confirm('Do you want to proceed?', false) then
                        exit;

                    if Rec.FindSet() then
                        repeat
                            ORBDimensionSetTreeNode.Init();
                            ORBDimensionSetTreeNode.TransferFields(Rec);
                            ORBDimensionSetTreeNode.Insert();
                        until Rec.Next() = 0;
                end;
            }
            action(TransferfromTemp)
            {
                Caption = 'Transfer From Temp';
                ApplicationArea = all;
                trigger OnAction()
                Var
                    ORBDimensionSetTreeNode: Record "ORB Dimension Set Tree Node";
                begin
                    if not Confirm('Do you want to proceed?', false) then
                        exit;

                    if ORBDimensionSetTreeNode.FindSet() then
                        repeat
                            Rec.Init();
                            Rec.TransferFields(ORBDimensionSetTreeNode);
                            Rec.Insert();
                        until ORBDimensionSetTreeNode.Next() = 0;
                end;
            }

            action(DeleteSetTree)
            {
                Caption = 'Delete Set Tree details';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to proceed?', false) then
                        exit;

                    Rec.DeleteAll();
                end;
            }


            action(DeleteTemp)
            {
                Caption = 'Delete Records in Temp';
                ApplicationArea = all;
                trigger OnAction()
                Var
                    ORBDimensionSetTreeNode: Record "ORB Dimension Set Tree Node";
                begin
                    if not Confirm('Do you want to proceed?', false) then
                        exit;

                    ORBDimensionSetTreeNode.DeleteAll();
                end;
            }
        }
    }
}
