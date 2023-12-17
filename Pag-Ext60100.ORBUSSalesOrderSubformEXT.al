pageextension 60100 "ORBUS.SalesOrderSubformEXT" extends "Sales Order Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Hardware Price"; Rec."Hardware Price")
            {
                ApplicationArea = All;
            }
            field("Graphics Price"; Rec."Graphics Price")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        //DimFix
        // modify(Dimensions)
        // {
        //     trigger OnBeforeAction()
        //     var
        //         DimSetEntry: Record "Dimension Set Entry";
        //         DimensionValues: Record "Dimension Value";
        //         var2: Text;
        //         GetValues: Codeunit GetDimSetValues;
        //     begin
        //         var1:=Rec."Shortcut Dimension 1 Code";
        //     end;
        //     trigger OnAfterAction()
        //     var
        //     begin
        //         Rec."Shortcut Dimension 1 Code":=var1;
        //         Rec.Modify();
        //     end;
        // }
        // addafter(Dimensions)
        // {
        //     action(testdimensionsetvalues)
        //     {
        //         ApplicationArea = All;

        //         trigger OnAction()
        //         var
        //             GetValues: Codeunit GetDimSetValues;
        //         begin
        //             if(Rec."Document Type" = Rec."Document Type"::Order) or (Rec."Document Type" = Rec."Document Type"::Quote) or (Rec."Document Type" = Rec."Document Type"::"Return Order")then GetValues.GetDimSetValues(Rec."Shortcut Dimension 1 Code", Rec."Dimension Set ID");
        //         end;
        //     }
        // }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.SetHardwareGraphicsPrice();
    end;

    var
        var1: Text;
}
