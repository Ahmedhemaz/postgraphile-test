import { makeExtendSchemaPlugin, gql, embed } from "graphile-utils";

const currentTopic = () => {
  return `graphql:message:1`;
};

// const message = (parent, args, context, info) => {
//   const { conversationId } = args;
// };

// const message = (sql, event, args, _context, { graphile: { selectGraphQLResultFromTable } }) => {
//   const { conversationId } = args;
//   const rows = await selectGraphQLResultFromTable(
//     sql.fragment`app_public.messages`,
//     (tableAlias, sqlBuilder) => {
//       sqlBuilder.where(sql.fragment`${tableAlias}.conversation_id = ${sql.value(event.subject)}`);
//     }
//   );
//   return rows[0];
// };

const subscriptionPlugIn = makeExtendSchemaPlugin((build) => {
  const { pgSql: sql } = build;

  return {
    typeDefs: gql`
        type ConversationSubscriptionPayload{
            data: String
        }

        extend type Subscription {
            message(conversationId: Int): ConversationSubscriptionPayload @pgSubscription(topic: ${embed(
              currentTopic
            )})
        }
      `,
    resolvers: {
      ConversationSubscriptionPayload: {
        message: async (parent, args, context, info) => {
          return "x";
        },
      },
    },
  };
});

export { subscriptionPlugIn };
