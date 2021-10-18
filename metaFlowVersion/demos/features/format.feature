// this is comment for feature files.
name <feature name>
description [\n|\t]{
	this is a multiple line of description, all content within {} block will
	be treated as part of the descriptions.
}
type

// multiple files are supported, each line within {} are treated as one file.
file {
	path0/path1/file
	path0/path2/file
}
