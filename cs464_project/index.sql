CREATE INDEX NameIndex
ON Hierarchy (Name);

CREATE INDEX KMerSequenceIndex
ON KMer(Sequence (100));

CREATE INDEX PhylumIndex
ON TaxonomicInfo(Phylum);
