begin;

    create table account(
        id serial primary key,
        email varchar(255) not null
    );

    insert into public.account(email)
    values
        ('aardvark@x.com'),
        ('bat@x.com');

    savepoint a;

    -- variable filter value
    select graphql.resolve($$
    mutation DeleteAccountByEmail($email: String!) {
      deleteFromAccountCollection(
        filter: {
          email: {eq: $email}
        }
        atMost: 1
      ) {
        id
      }
    }
    $$, '{"email": "bat@x.com"}');

    rollback to savepoint a;

    -- variable entire filter
    select graphql.resolve($$
        mutation DeleteAccountByFilter($afilt: AccountFilter!) {
          deleteFromAccountCollection(
            filter: $afilt
            atMost: 1
          ) {
            id
          }
        }
        $$,
        variables:= '{"afilt": {"id": {"eq": 1}} }'
    );
    rollback to savepoint a;

    -- variable atMost. should impact too many
    select graphql.resolve($$
        mutation SafeDeleteAccount($atMost: Int!) {
          deleteFromAccountCollection(
            filter: {id: {eq: 1}}
            atMost: $atMost
          ) {
            id
          }
        }
        $$,
        variables:= '{"atMost": 0 }'
    );
    rollback to savepoint a;

rollback;
