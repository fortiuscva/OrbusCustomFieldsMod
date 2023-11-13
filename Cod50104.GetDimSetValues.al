codeunit 50104 GetDimSetValues
{
    Permissions = tabledata "Dimension Set Entry" = RIMD;
    //DimFix
    // procedure GetDimSetValues(var3: Text; var4: Integer)
    // var
    //     DimSetEntry: Record "Dimension Set Entry";
    //     DimensionValues: Record "Dimension Value";
    //     var2: Text;
    //     var5: Integer;
    // begin
    //     DimensionValues.Reset();
    //     DimensionValues.SetRange("Global Dimension No.", 1);
    //     DimensionValues.SetRange(Code, var3);
    //     if DimensionValues.FindFirst()then begin
    //         var2:=DimensionValues.Name;
    //         var5:=DimensionValues."Dimension Value ID";
    //     end;
    //     DimSetEntry.Init();
    //     DimSetEntry."Dimension Set ID":=var4;
    //     DimSetEntry."Dimension Code":='LOC';
    //     DimSetEntry."Dimension Value Code":=var3;
    //     DimSetEntry."Dimension Value Name":=var2;
    //     DimSetEntry."Dimension Value ID":=var5;
    //     DimSetEntry.Insert();
    // end;
    // procedure ModifyDimSetValuesForLines(Var1: Integer; Var2: Code[20])
    // var
    //     DimSetEntry: Record "Dimension Set Entry";
    //     DimensionValues: Record "Dimension Value";
    // begin
    //     DimSetEntry.Reset();
    //     DimSetEntry.SetRange("Dimension Set ID", Var1);
    //     DimSetEntry.SetRange("Dimension Code", 'LOC');
    //     if DimSetEntry.FindFirst()then begin
    //         if DimSetEntry."Dimension Value Code" = Var2 then exit
    //         else
    //         begin
    //             DimensionValues.Reset();
    //             DimensionValues.SetRange("Global Dimension No.", 1);
    //             DimensionValues.SetRange(Code, Var2);
    //             if DimensionValues.FindFirst()then begin
    //                 DimSetEntry."Dimension Value Code":=Var2;
    //                 DimSetEntry."Dimension Value ID":=DimensionValues."Dimension Value ID";
    //                 DimSetEntry."Dimension Value Name":=DimensionValues.Name;
    //                 DimSetEntry.Modify();
    //             end;
    //         end;
    //     end;
    // end;
}
