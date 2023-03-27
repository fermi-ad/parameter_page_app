// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gql/ast.dart' as _i1;

const StreamData = _i1.OperationDefinitionNode(
  type: _i1.OperationType.subscription,
  name: _i1.NameNode(value: 'StreamData'),
  variableDefinitions: [
    _i1.VariableDefinitionNode(
      variable: _i1.VariableNode(name: _i1.NameNode(value: 'drfs')),
      type: _i1.ListTypeNode(
        type: _i1.NamedTypeNode(
          name: _i1.NameNode(value: 'String'),
          isNonNull: true,
        ),
        isNonNull: true,
      ),
      defaultValue: _i1.DefaultValueNode(value: null),
      directives: [],
    )
  ],
  directives: [],
  selectionSet: _i1.SelectionSetNode(selections: [
    _i1.FieldNode(
      name: _i1.NameNode(value: 'acceleratorData'),
      alias: null,
      arguments: [
        _i1.ArgumentNode(
          name: _i1.NameNode(value: 'drfs'),
          value: _i1.VariableNode(name: _i1.NameNode(value: 'drfs')),
        )
      ],
      directives: [],
      selectionSet: _i1.SelectionSetNode(selections: [
        _i1.FieldNode(
          name: _i1.NameNode(value: 'refId'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        _i1.FieldNode(
          name: _i1.NameNode(value: 'cycle'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: null,
        ),
        _i1.FieldNode(
          name: _i1.NameNode(value: 'data'),
          alias: null,
          arguments: [],
          directives: [],
          selectionSet: _i1.SelectionSetNode(selections: [
            _i1.FieldNode(
              name: _i1.NameNode(value: 'timestamp'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            _i1.FieldNode(
              name: _i1.NameNode(value: 'result'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: _i1.SelectionSetNode(selections: [
                _i1.InlineFragmentNode(
                  typeCondition: _i1.TypeConditionNode(
                      on: _i1.NamedTypeNode(
                    name: _i1.NameNode(value: 'StatusReply'),
                    isNonNull: false,
                  )),
                  directives: [],
                  selectionSet: _i1.SelectionSetNode(selections: [
                    _i1.FieldNode(
                      name: _i1.NameNode(value: 'status'),
                      alias: null,
                      arguments: [],
                      directives: [],
                      selectionSet: null,
                    )
                  ]),
                ),
                _i1.InlineFragmentNode(
                  typeCondition: _i1.TypeConditionNode(
                      on: _i1.NamedTypeNode(
                    name: _i1.NameNode(value: 'Scalar'),
                    isNonNull: false,
                  )),
                  directives: [],
                  selectionSet: _i1.SelectionSetNode(selections: [
                    _i1.FieldNode(
                      name: _i1.NameNode(value: 'scalarValue'),
                      alias: null,
                      arguments: [],
                      directives: [],
                      selectionSet: null,
                    )
                  ]),
                ),
              ]),
            ),
          ]),
        ),
      ]),
    )
  ]),
);
const document = _i1.DocumentNode(definitions: [StreamData]);
