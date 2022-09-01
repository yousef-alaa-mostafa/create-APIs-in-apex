-- 1- create role and privilage
DECLARE

la_roles1          owa.vc_arr;
la_priv_patterns1  owa.vc_arr;

BEGIN

ords.create_role(p_role_name => 'Parameterize_api_access_role'); -- Parameterize_api_access_role = role name

la_roles1(1) := 'Parameterize_api_access_role';

ords.define_privilege(p_privilege_name => 'Parameterize_api_access_priv', -- Parameterize_api_access_priv = privilage name
                      p_roles           => la_roles1,
                      p_label    => 'Employees data Access',
                      p_description => 'Employees data Access');

/* https://bayanbook.com:8181/fama/development/token/getall    im using privious Paramterize API */ 

la_priv_patterns1(1) := '/token/getall'; ------------ this is api pattern 

ords.create_privilege_mapping (p_privilege_name => 'Parameterize_api_access_priv',
                               p_patterns       => la_priv_patterns1);


COMMIT;

END;     

-- 2- creacte client with privilage to created role
BEGIN

  OAUTH.CREATE_CLIENT(
    p_name            => 'Get_Access_data',
    p_grant_type      => 'client_credentials',
    p_owner           => 'Knowledge Sign',
    p_description     => 'oauth client user',
    p_support_email   => 'knowledgesign22@gmail.com',
    p_privilege_names => 'Parameterize_api_access_priv');
  OAUTH.GRANT_CLIENT_ROLE(
    p_client_name => 'Get_Access_data',
    p_role_name   => 'Parameterize_api_access_role'
  );
  COMMIT; 

END;

-- 3- run the query and check created client data
SELECT id, name, description, client_id, client_secret
FROM user_ords_clients