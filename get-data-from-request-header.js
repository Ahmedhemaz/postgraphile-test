const { makeExtendSchemaPlugin, gql } = require("graphile-utils");

const MyPlugin = makeExtendSchemaPlugin((build) => {
  // Get any helpers we need from `build`
  const { pgSql: sql, inflection } = build;

  return {
    typeDefs: gql`
      extend type Query {
        headers: Boolean
      }
    `,
    resolvers: {
      Query: {
        headers: async (parent, args, context, resInfo) => {
          //   console.log(parent);
          //   console.log(args);
          console.log(context);
          //   console.log(resInfo);
          return true;
        },
      },
    },
  };
});

export { MyPlugin };
