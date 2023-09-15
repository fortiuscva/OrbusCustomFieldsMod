pageextension 50104 SalesOrderPageEx extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field(SystemCreatedAt; rec.SystemCreatedAt)
            {
                ApplicationArea = All;
            }
            field(SystemModifiedAt; rec.SystemModifiedAt)
            {
                ApplicationArea = All;
            }
            field("Order Status"; rec."Order Status")
            {
                ApplicationArea = All;
            }
            field("Production Scan Time"; Rec."Production Scan Time")
            {
                ApplicationArea = All;
                Caption = 'Production Scan Time';
                Editable = false;
            }
        }
        addafter("External Document No.")
        {
            field("Project No."; Rec."Project No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = false;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                Rec."Location Override":=true;
                CurrPage.Update(true);
            end;
        }
        modify("Ship-to Address")
        {
            Visible = true;
        }
        modify("Ship-to Address 2")
        {
            Visible = true;
        }
        modify("Ship-to City")
        {
            Visible = true;
        }
        modify("Ship-to County")
        {
            Visible = true;

            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader.Get(Rec."Document Type", Rec."No.");
                SalesHeader:=Rec;
                //SalesHeader."Ship-to County" := Rec."Ship-to County";
                SalesHeader.Modify(true);
                CurrPage.Update(false);
            end;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = true;
        }
        modify("Ship-to Post Code")
        {
            Visible = true;
        }
        modify(Control4)
        {
            Visible = true;
        }
        addafter("Posting Date")
        {
            field("Approval Deadline"; Rec."Approval Deadline")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Industry Shortcut Dimension"; Rec."Industry Shortcut Dimension")
            {
                ApplicationArea = All;
                Caption = 'Industry Code';
                Editable = false;
            }
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                Customer.Reset();
                Customer.SetRange("No.", Rec."Sell-to Customer No.");
                if Customer.FindFirst()then begin
                    Rec."Industry Shortcut Dimension":=Customer."Shortcut Dimension 6 Code";
                    Rec.Modify();
                end;
            end;
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                Customer.Reset();
                Customer.SetRange(Name, Rec."Sell-to Customer Name");
                if Customer.FindFirst()then begin
                    Rec."Industry Shortcut Dimension":=Customer."Shortcut Dimension 6 Code";
                    Rec.Modify();
                end;
            end;
        }
        modify(ShippingOptions)
        {
            trigger OnAfterValidate()
            var
                OrbusLocation: Record OrbusLocations;
                SalesLine: Record "Sales Line";
            begin
                OrbusLocation.Reset();
                OrbusLocation.SetRange("Orbus State Text", Rec."Ship-to County");
                if OrbusLocation.FindFirst()then begin
                    Rec."Location Code":=OrbusLocation.OrbusLocation;
                    Rec."Shortcut Dimension 1 Code":=OrbusLocation.OrbusLocation;
                    Rec.Modify();
                    SalesLine.Reset();
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindSet()then repeat SalesLine."Location Code":=OrbusLocation.OrbusLocation;
                            SalesLine."Shortcut Dimension 1 Code":=OrbusLocation.OrbusLocation;
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                end;
            end;
        }
    }
    actions
    {
        // Add changes to page actions here
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                userSetup: Record "User Setup";
                GetDimSetValues: Codeunit GetDimSetValues;
                SalesLine: Record "Sales Line";
                DimensionSetEntry: Record "Dimension Set Entry";
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
            begin
                userSetup.Get(UserId);
                if NOT userSetup.AllowRelease then begin
                    Error('You are not allowed to Release Sales Orders');
                end;
            end;
            trigger OnAfterAction()
            var
                SaleslIne: Record "Sales Line";
                DimensionSetEntry: Record "Dimension Set Entry";
                GetDimSetValues: Codeunit GetDimSetValues;
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", Rec."No.");
                if SalesLine.FindSet()then repeat SalesLine."Shortcut Dimension 1 Code":=SalesLine."Location Code";
                        SalesLine.Modify();
                        DimensionSetEntry.Reset();
                        DimensionSetEntry.SetRange("Dimension Set ID", SalesLine."Dimension Set ID");
                        DimensionSetEntry.SetFilter("Dimension Code", 'LOC');
                        if DimensionSetEntry.FindFirst()then begin
                            GetDimSetValues.ModifyDimSetValuesForLines(SalesLine."Dimension Set ID", SalesLine."Location Code");
                        end
                        else
                            GetDimSetValues.GetDimSetValues(SalesLine."Shortcut Dimension 1 Code", SalesLine."Dimension Set ID");
                    until SalesLine.Next() = 0;
                ModLocationCodeHeader.InsertDimensionSetEntryFromSalesHeader(Rec);
            end;
        }
        modify("Release & Pick")
        {
            trigger OnBeforeAction()
            var
                userSetup: Record "User Setup";
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
                Salesline: Record "Sales Line";
            begin
                userSetup.Get(UserId);
                if NOT userSetup.AllowRelease then begin
                    Error('You are not allowed to Release Sales Orders');
                end;
            end;
            trigger OnAfterAction()
            var
                SalesLine: Record "Sales Line";
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
            begin
                Rec."Order Status":=Rec."Order Status"::"Pick Released";
                Rec.Modify();
                CurrPage.Update();
                Salesline.Reset();
                Salesline.SetRange("Document No.", Rec."No.");
                if Salesline.FindSet()then repeat Salesline."Shortcut Dimension 1 Code":=Salesline."Location Code";
                        Salesline.Modify();
                    until Salesline.Next() = 0;
                ModLocationCodeHeader.InsertDimensionSetEntryFromSalesHeader(Rec);
            end;
        }
        modify("Create &Warehouse Shipment")
        {
            trigger OnAfterAction()
            var
                SalesLine: Record "Sales Line";
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
            begin
                Salesline.Reset();
                Salesline.SetRange("Document No.", Rec."No.");
                if Salesline.FindSet()then repeat Salesline."Shortcut Dimension 1 Code":=Salesline."Location Code";
                        Salesline.Modify();
                    until Salesline.Next() = 0;
                ModLocationCodeHeader.InsertDimensionSetEntryFromSalesHeader(Rec);
            end;
        }
        addlast("&Print")
        {
            action("Print Work Orders and Production")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Category11";
                Image = Print;

                trigger OnAction()
                var
                    ProdHdr: Record "Production Order";
                    SalesHdr: Record "Sales Header";
                begin
                    SalesHdr.SetRange("Document Type", Rec."Document Type");
                    SalesHdr.SetRange("No.", Rec."No.");
                    SalesHdr.FindSet();
                    Report.Run(Report::"Work Order", false, false, SalesHdr);
                    ProdHdr.reset;
                    // ProdHdr.SetRange("Source No.", Rec."No.");
                    // ProdHdr.SetRange("Source Type", ProdHdr."Source Type"::"Sales Header");
                    ProdHdr.SetRange("Sales Order No.", SalesHdr."No.");
                    if ProdHdr.FindSet()then Report.Run(Report::"Custom Production Order", false, false, ProdHdr);
                end;
            }
            action(GetLocationEnums)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    OrbusLocatiosn: Record OrbusLocations;
                begin
                    OrbusLocatiosn.Reset();
                    if OrbusLocatiosn.FindSet()then repeat OrbusLocatiosn."Orbus State Text":=Format(OrbusLocatiosn.OrbusState, 0, '<Text>');
                            OrbusLocatiosn.Modify();
                        until OrbusLocatiosn.Next() = 0;
                end;
            }
        }
        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Reset();
                UserSetup.SetRange("User ID", UserId());
                if UserSetup.FindFirst()then begin
                    if UserSetup.AllowRelease = false then Error('User: %1 does not have permission to change status on sales order back to "open"', UserId());
                end;
            end;
        }
        /*modify("Pla&nning")
        {
            trigger OnBeforeAction()
            var
                ModLocationCodeHeader: Codeunit ModLocationCodeHeader;
            begin
                ModLocationCodeHeader.InsertDimensionSetEntryFromSalesHeader(Rec);
            end;
        }*/
        modify(Dimensions)
        {
            trigger OnBeforeAction()
            var
            begin
                var1:=Rec."Location Code";
            end;
            trigger OnAfterAction()
            var
            begin
                Rec."Location Code":=var1;
                Rec."Shortcut Dimension 1 Code":=var1;
                Rec.Modify();
            end;
        }
    }
    var var1: Text;
}
