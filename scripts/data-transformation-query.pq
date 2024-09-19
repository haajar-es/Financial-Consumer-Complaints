//Facts - Complaints

let
    Source = #"Financial Consumer Complaints Stg",
    #"Merged Queries" = Table.NestedJoin(Source, {"Product", "Sub-product"}, Product, {"Product", "Sub-product"}, "Product.1", JoinKind.Inner),
    #"Expanded Product.1" = Table.ExpandTableColumn(#"Merged Queries", "Product.1", {"Product RK"}, {"Product RK"}),
    #"Merged Queries1" = Table.NestedJoin(#"Expanded Product.1", {"Issue", "Sub-issue"}, Issues, {"Issue", "Sub-issue"}, "Issues", JoinKind.Inner),
    #"Expanded Issues" = Table.ExpandTableColumn(#"Merged Queries1", "Issues", {"Issue SK"}, {"Issue SK"}),
    #"Merged Queries2" = Table.NestedJoin(#"Expanded Issues", {"Company", "State", "ZIP code"}, Company, {"Company", "State abbr", "ZIP code"}, "Company.1", JoinKind.Inner),
    #"Expanded Company.1" = Table.ExpandTableColumn(#"Merged Queries2", "Company.1", {"Company SK"}, {"Company SK"}),
    #"Merged Queries3" = Table.NestedJoin(#"Expanded Company.1", {"Company public response", "Tags", "Consumer consent provided?", "Submitted via", "Company response to consumer", "Timely response?", "Consumer disputed?"}, #"Complaint Detail", {"Company public response", "Tags", "Consumer consent provided?", "Submitted via", "Company response to consumer", "Timely response?", "Consumer disputed?"}, "Complaint Detail", JoinKind.Inner),
    #"Expanded Complaint Detail" = Table.ExpandTableColumn(#"Merged Queries3", "Complaint Detail", {"Complaint Detail SK"}, {"Complaint Detail SK"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Expanded Complaint Detail",{"Complaint ID", "Date Sumbited", "Date Received", "Product RK", "Issue SK", "Company SK", "Complaint Detail SK"})
in
    #"Removed Other Columns"



// Dimensions - Issues

let
    Source = #"Financial Consumer Complaints Stg",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Issue", "Sub-issue"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
    #"Added Index" = Table.AddIndexColumn(#"Removed Duplicates", "Index", 1, 1, Int64.Type),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Index",{"Index", "Issue", "Sub-issue"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Index", "Issue SK"}})
in
    #"Renamed Columns"


// Dimensions - Product

let
    Source = #"Financial Consumer Complaints Stg",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Product", "Sub-product"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
    #"Added Index" = Table.AddIndexColumn(#"Removed Duplicates", "Index", 1, 1, Int64.Type),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Index",{"Index", "Product", "Sub-product"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Index", "Product RK"}})
in
    #"Renamed Columns"


// Dimensions - Company

let
    Source = #"Financial Consumer Complaints Stg",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Company", "State", "ZIP code"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
    #"Added Index" = Table.AddIndexColumn(#"Removed Duplicates", "Index", 1, 1, Int64.Type),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Index",{"Index", "Company", "State", "ZIP code"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Index", "Company SK"}, {"State", "State abbr"}}),
    #"Merged Queries" = Table.NestedJoin(#"Renamed Columns", {"State abbr"}, #"State Mappings", {"State abbr"}, "State Mappings", JoinKind.LeftOuter),
    #"Expanded State Mappings" = Table.ExpandTableColumn(#"Merged Queries", "State Mappings", {"State", "xPosition", "yPosition"}, {"State", "xPosition", "yPosition"})
in
    #"Expanded State Mappings"


// Dimensions - Complaint Details

let
    Source = #"Financial Consumer Complaints Stg",
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Company public response", "Tags", "Consumer consent provided?", "Submitted via", "Company response to consumer", "Timely response?", "Consumer disputed?"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
    #"Added Index" = Table.AddIndexColumn(#"Removed Duplicates", "Index", 1, 1, Int64.Type),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Index",{"Index", "Company public response", "Tags", "Consumer consent provided?", "Submitted via", "Company response to consumer", "Timely response?", "Consumer disputed?"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Index", "Complaint Detail SK"}})
in
    #"Renamed Columns"