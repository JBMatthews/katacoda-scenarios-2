
The apt module allows you to specify the state you wish the package to be in.

If you want a specific version, you append it to the package name, for example:

```
    - name: ensure sysstat is installed at version 10.2.0-1
      apt:
        name: sysstat=10.2.0-1
        state: installed
```

1\. However, if you want to ensure that the package is not installed, you can declare `state: absent`, and Ansible will ensure it remains absent.

Try it! Update the playbook using `sed`, to remove `sysstat`, like this:

`sed -i -e 's/state: latest/state: absent/' -e 's/ensure.*/ensure sysstat is removed/' playbook.yml`{{execute}}

2\. Now, re-run the playbook:

`ansible-playbook -i myhosts playbook.yml`{{execute}}

3\. Based on what you learned from the previous step, what happens if you run it again?

`ansible-playbook -i myhosts playbook.yml`{{execute}}

Pretty cool, huh?

>SUCCESS!
