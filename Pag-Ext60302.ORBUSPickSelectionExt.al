pageextension 60302 "ORBUS.PickSelectionExt" extends "Pick Selection"
{
    Editable = true;

    layout
    {
        modify(Control1)
        {
            Editable = false;
        }
        addbefore(Control1)
        {
            group(DateFilterGroup)
            {
                Caption = 'Filters';

                field(DateFilter; DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Date Filter';
                    Editable = true;

                    trigger OnValidate()
                    var
                        WhsePickRequest: Record "Whse. Pick Request";
                        var1: Text;
                    begin
                        if DateFilter = 0D then begin
                            Rec.Reset();
                            CurrPage.Update();
                        end
                        else
                        begin
                            Rec.Reset();
                            Rec.SetRange("Start/Ship Date", DateFilter);
                            CurrPage.Update();
                        end end;
                }
            }
        }
        addafter("Document No.")
        {
            field("Start/Ship Date"; Rec."Start/Ship Date")
            {
                Caption = 'Start/Ship Date';
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetStartShipDate();
    end;
    local procedure SetStartShipDate()
    var
        ProdOrder: Record "Production Order";
        WhseShipment: Record "Warehouse Shipment Header";
    begin
        IF Rec."Document No." = '' then exit;
        Case Rec."Document Type" of Rec."Document Type"::Production: begin
            ProdOrder.GET(ProdOrder.Status::Released, Rec."Document No.");
            Rec."Start/Ship Date":=ProdOrder."Starting Date";
        end;
        Rec."Document Type"::Shipment: begin
            WhseShipment.GET(Rec."Document No.");
            Rec."Start/Ship Date":=WhseShipment."Shipment Date";
        end;
        End;
        Rec.Modify()end;
    var StartShipDate: Date;
    DateFilter: Date;
}
