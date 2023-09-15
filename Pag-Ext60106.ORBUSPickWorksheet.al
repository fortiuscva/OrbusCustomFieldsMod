pageextension 60106 "ORBUS.PickWorksheet" extends "Pick Worksheet"
{
    layout
    {
        addbefore("Due Date")
        {
            field("Start Date"; Rec."Start Date")
            {
                ShowMandatory = IsStartReq;
                ApplicationArea = All;
            }
            field("Ship Date"; Rec."Ship Date")
            {
                ApplicationArea = All;
                ShowMandatory = IsShipReq;
            }
        }
    }
    actions
    {
        modify(CreatePick)
        {
            trigger OnBeforeAction()
            var
                OrbusSubMgt: Codeunit "ORBUS.SubscriptionMgt";
            begin
                OrbusSubMgt.WhseOnBeforeRun(Rec);
            end;
        }
    }
    trigger OnAfterGetRecord()
    begin
        clear(IsStartReq);
        clear(IsShipReq);
        IsStartReq:=Rec."Whse. Document Type" = Rec."Whse. Document Type"::Production;
        IsShipReq:=Rec."Whse. Document Type" = Rec."Whse. Document Type"::Shipment;
        Rec.SetStartShipDate();
    end;
    var IsStartReq: Boolean;
    IsShipReq: Boolean;
}
