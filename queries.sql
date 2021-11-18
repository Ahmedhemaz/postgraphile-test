CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE IF NOT EXISTS users(
	ID SERIAL NOT NULL PRIMARY KEY,
  	NAME VARCHAR UNIQUE NOT NULL,
  	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
)

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON public_chat.users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();


CREATE TABLE IF NOT EXISTS public_chat.conversations(
	ID SERIAL NOT NULL PRIMARY KEY,
  	NAME VARCHAR,
  	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
)


CREATE TRIGGER set_timestamp
BEFORE UPDATE ON public_chat.conversations
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TABLE IF NOT EXISTS public_chat.users_conversations(
	USER_ID INT NOT NULL ,
	CONVERSATION_ID INT NOT NULL,
  	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (USER_ID, CONVERSATION_ID),
    FOREIGN KEY (USER_ID)
      REFERENCES public_chat.users (ID),
    FOREIGN KEY (CONVERSATION_ID)
      REFERENCES public_chat.conversations (ID)
)


CREATE TABLE IF NOT EXISTS public_chat.messages(
    ID SERIAL NOT NULL PRIMARY KEY,
	USER_ID INT NOT NULL ,
	CONVERSATION_ID INT NOT NULL,
    CONTENT TEXT NOT NULL,
    ATTACHMENT VARCHAR,
  	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (USER_ID)
      REFERENCES public_chat.users (ID),
    FOREIGN KEY (CONVERSATION_ID)
      REFERENCES public_chat.conversations (ID)
)







CREATE OR REPLACE FUNCTION publish_message_to_conversation_topic(conversation_id int)
RETURNS TRIGGER AS $$
DECLARE
v_record record
v_topic text;
BEGIN
  --  v_topic := 'graphql:message:' || conversation_id ||;
   v_topic = concat('graphql:message:', conversation_id)
   perform pg_notify(v_topic, json_build_object('message', v_event)::text);
END;
$$ LANGUAGE plpgsql;



select  concat_topic_with_id(t.conversation_id) from (select * from public_chat.messages where id = 1)t;

 select pg_notify('graphql:message:1', json_build_object(
         'data',  '4'
       )::text);

select(select row_to_json(t) from 
(select * from public_chat.messages 
where id = 1)t)