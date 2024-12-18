-- Add up migration script here
CREATE TABLE
    IF NOT EXISTS InstanceData (
            did INT AUTO_INCREMENT PRIMARY KEY,
            hash BINARY(20) NOT NULL,
            data LONGBLOB,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

            UNIQUE INDEX `idx_hash` (`hash`)
    );

CREATE TABLE
    IF NOT EXISTS Instance (
        iid INT AUTO_INCREMENT PRIMARY KEY,
        data_did INT NOT NULL,

        nodes INT UNSIGNED NOT NULL,
        edges INT UNSIGNED NOT NULL,

        name VARCHAR(255),
        description TEXT,

        submitted_by VARCHAR(255),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

        INDEX `idx_nodes` (`nodes`),
        INDEX `idx_edges` (`edges`),

        FOREIGN KEY (data_did) REFERENCES InstanceData(did)
    );

CREATE TABLE
    IF NOT EXISTS Tag (
        tid INT AUTO_INCREMENT PRIMARY KEY,
        description TEXT,
        name VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
        style INT UNSIGNED NOT NULL,
        UNIQUE INDEX `idx_name` (`name`)
    );

CREATE TABLE
    IF NOT EXISTS InstanceTag (
        instance_iid INT NOT NULL,
        tag_tid INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
        PRIMARY KEY (instance_iid, tag_tid),
        FOREIGN KEY (instance_iid) REFERENCES Instance(iid),
        FOREIGN KEY (tag_tid) REFERENCES Tag(tid)
    );

CREATE TABLE
    IF NOT EXISTS SolverRun (
        sr_id INT AUTO_INCREMENT PRIMARY KEY,
        run_uuid BINARY(16) NOT NULL,
        solver_uuid BINARY(16),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
        
        UNIQUE INDEX `idx_uuid` (`run_uuid`)
    );

CREATE TABLE
    IF NOT EXISTS SolutionData (
            sdid INT AUTO_INCREMENT PRIMARY KEY,
            hash BINARY(20) NOT NULL,
            data LONGBLOB,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
            UNIQUE INDEX `idx_hash` (`hash`)
    );


CREATE TABLE
    IF NOT EXISTS Solution (
        sid INT AUTO_INCREMENT PRIMARY KEY,
        sr_uuid BINARY(16) NOT NULL,
        instance_iid INT NOT NULL,

        solution_hash BINARY(20),
        error_code INT UNSIGNED,
        score INT UNSIGNED,
        seconds_computed DOUBLE NOT NULL,

        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (instance_iid) REFERENCES Instance(iid),
        FOREIGN KEY (sr_uuid) REFERENCES SolverRun(run_uuid),
        FOREIGN KEY (solution_hash) REFERENCES SolutionData(hash),

        UNIQUE INDEX `idx_sr_uuid_instance_iid` (`sr_uuid`, `instance_iid`)
    );



